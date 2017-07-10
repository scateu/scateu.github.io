---
layout: page
title: Scan
permalink: /scan/
---

<script src="/assets/js/qrcode.min.js"></script>

## Wechat

<div id="qrcode"></div>

<script>
var qrcode = new QRCode('qrcode', {
  text: 'http://weixin.qq.com/r/mJEMFHXEsCjPrTF398SK',
  width: 256,
  height: 256,
  colorDark: '#000000',
  colorLight: '#ffffff',
  correctLevel: QRCode.CorrectLevel.H
});
</script>
