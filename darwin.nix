{ pkgs, ... }:
{
  # システム全体にインストールするパッケージ
  environment.systemPackages = [ pkgs.git ];

  # nix-darwin のバージョン互換性の基準点（初回設定時の値を変えない）
  system.stateVersion = 6;

  home-manager = {
    useGlobalPkgs = true; # システムのpッケージをユーザーレベルでも利用可能にする
    useUserPackages = true; # ユーザーレベルのパッケージを有効にする
    users."naokihaba" = import ./home.nix; # ユーザーごとの設定ファイルをインポートする
  };
}
