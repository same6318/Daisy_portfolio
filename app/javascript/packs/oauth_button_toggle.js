
document.addEventListener('turbolinks:load', function () {
  var checkbox = document.getElementById('agreement-checkbox');
  var googleButton = document.getElementById('google-register-button');
  
  if (checkbox && googleButton) {
    googleButton.disabled = false;

    checkbox.addEventListener('change', function () {
      googleButton.disabled = !checkbox.checked; // チェックボックスがチェックされていない場合はボタンを無効に
    });
    
    googleButton.addEventListener('click', function (event) {
      if (!checkbox.checked) {
        event.preventDefault(); // チェックがない場合、ボタンのデフォルトの動作を防ぐ
        alert('利用規約およびプライバシーポリシーに同意してください。');
      }
    });
  }
});

