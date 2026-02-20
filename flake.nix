{
  description = "NixOS configuration with Flakes";

  # inputs: 外部の依存関係を宣言する。npm の package.json の dependencies に相当
  inputs = {
    # nixpkgs: 数万のパッケージを含む Nix 公式リポジトリ
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nix-darwin: macOS を NixOS のように宣言型で管理するツール
    "nix-darwin" = {
      url = "github:nix-darwin/nix-darwin";
      # follows: nix-darwin が使う nixpkgs をこちらと共有する（重複ダウンロード防止）
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs: このフレークが外部に提供するものを宣言する関数
  # 引数は inputs の内容が自動で渡される
  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    {
      # darwinConfigurations: macOS マシンの設定（NixOS の nixosConfigurations に相当）
      darwinConfigurations."my-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Apple Silicon Mac

        # modules: 設定の本体。複数ファイルに分割して合成できる
        modules = [
          (
            { pkgs, ... }:
            {
              # システム全体にインストールするパッケージ
              environment.systemPackages = [ pkgs.git ];

              # nix-darwin のバージョン互換性の基準点（初回設定時の値を変えない）
              system.stateVersion = 6;
            }
          )
        ];
      };
    };
}
