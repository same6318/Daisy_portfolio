// app/assets/javascripts/application.js
document.addEventListener('DOMContentLoaded', function() {
  // フラッシュメッセージを5秒後にフェードアウトして消す
  setTimeout(function() {
    var flashNotice = document.getElementById('flash-new-user-notice');
    if (flashNotice) {
      flashNotice.style.transition = 'opacity 1s';
      flashNotice.style.opacity = '0';
      setTimeout(function() {
        flashNotice.remove();
      }, 1000); // フェードアウト後に完全に削除
    }
  }, 5000); // 5秒後にフェードアウトを開始
});
