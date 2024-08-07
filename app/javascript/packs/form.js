// $(function() {
document.addEventListener('turbolinks:load', () => {
  $("#input-text").on("keyup", function() {
    let countNum = String($(this).val().length);
    $("#counter").text("現在 " + countNum + "文字");

    // 100文字を超えた場合の処理
    if (countNum > 100) {
      $("#counter").css("color", "green"); // 緑色に変更
    } else {
      $("#counter").css("color", ""); // デフォルトの色に戻す
    }
  });
});
