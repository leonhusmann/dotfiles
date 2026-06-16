{ pkgs }:

pkgs.buildGoModule {
  pname = "threedots-cli";
  version = "0.1.82";

  src = pkgs.fetchFromGitHub {
    owner = "ThreeDotsLabs";
    repo = "cli";
    rev = "v0.1.82";
    sha256 = "1qlzl2rhv1gkg7iv9ifm48py1b3awanwgdwk3dag24k1fhww58dj";
  };

  vendorHash = "sha256-v9o9fnhKFYIeLy8xfRQoLOoB4dzcoqGi8i3Qq61p6xA=";

  ldflags = [ "-s" "-w" "-X main.version=0.1.82" "-X main.commit=6411fc3" ];

  doCheck = false;

  meta = {
    description = "ThreeDots CLI";
    homepage = "https://github.com/ThreeDotsLabs/cli";
    mainProgram = "tdl";
  };
}
