{...}: (self: super: {
  # 小鹤音形配置，配置来自 flypy.com 官方网盘的鼠须管配置压缩包「小鹤音形“鼠须管”for macOS.zip」
  # 我仅修改了 default.yaml 文件，将其中的半角括号改为了直角括号「 与 」。
  rime-data = ./tiger-code;
  fcitx5-rime = super.fcitx5-rime.override {rimeDataPkgs = [./tiger-code];};
})
