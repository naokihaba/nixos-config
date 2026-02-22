{
  description = "NixOS configuration with Flakes";

  # inputs: 外部の依存関係を宣言する。npm の package.json の dependencies に相当
  inputs = {
    # nixpkgs: 数万のパッケージを含む Nix 公式リポジトリ
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-stable: 安定版 nixpkgs。特定パッケージだけ stable を使いたい時に参照する
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # nix-darwin: macOS を NixOS のように宣言型で管理するツール
    "nix-darwin" = {
      url = "github:nix-darwin/nix-darwin";
      # follows: nix-darwin が使う nixpkgs をこちらと共有する（重複ダウンロード防止）
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager: ユーザーレベルの設定管理ツール（nix-darwin と組み合わせて使うことが多い）
    "home-manager" = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs: このフレークが外部に提供するものを宣言する関数
  # 引数は inputs の内容が自動で渡される
  outputs =
    # inputs@{ ... }: すべての inputs を受け取る。必要なものだけ引数に書いてもよい
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nixpkgs-stable,
      ...
    }:
    {
      # darwinConfigurations: macOS マシンの設定（NixOS の nixosConfigurations に相当）
      darwinConfigurations."my-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Apple Silicon Mac
        specialArgs = {
          # inputs: 全 inputs をモジュールに渡す（inputs.nixpkgs 等でアクセス可能）
          inherit inputs;
          # pkgs-stable: stable 版 nixpkgs のパッケージセット
          # darwin.nix や home.nix で { pkgs-stable, ... }: と受け取って使う
          pkgs-stable = import nixpkgs-stable {
            system = "aarch64-darwin";
            config.allowUnfree = true; # 非フリーパッケージを許可
          };
        };

        # modules: 設定の本体。複数ファイルに分割して合成できる
        modules = [
          home-manager.darwinModules.home-manager
          ./darwin.nix
        ];
      };
    };
}
