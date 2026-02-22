document.addEventListener("DOMContentLoaded", function() {
  var toggleBtn = document.getElementById('dark-mode-toggle');
  var currentTheme = localStorage.getItem('theme');

  // Apply saved theme on load
  if (currentTheme === 'dark') {
    document.documentElement.setAttribute('data-theme', 'dark');
    if (toggleBtn) {
      toggleBtn.innerHTML = '<i class="fas fa-sun"></i>';
    }
  }

  // Also respect system preference if no saved preference
  if (!currentTheme && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.setAttribute('data-theme', 'dark');
    localStorage.setItem('theme', 'dark');
    if (toggleBtn) {
      toggleBtn.innerHTML = '<i class="fas fa-sun"></i>';
    }
  }

  if (toggleBtn) {
    toggleBtn.addEventListener('click', function() {
      var current = document.documentElement.getAttribute('data-theme');
      if (current === 'dark') {
        document.documentElement.setAttribute('data-theme', 'light');
        localStorage.setItem('theme', 'light');
        toggleBtn.innerHTML = '<i class="fas fa-moon"></i>';
      } else {
        document.documentElement.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
        toggleBtn.innerHTML = '<i class="fas fa-sun"></i>';
      }
    });
  }
});
