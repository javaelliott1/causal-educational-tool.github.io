// Sidebar persistent toggle
const sidebar = document.getElementById('sidebar');
const showBtn = document.getElementById('showSidebar');

showBtn.onclick = () => {
  sidebar.classList.toggle('-translate-x-full');
};

// Learn submenu toggle
const learnToggle = document.getElementById('learnToggle');
const learnSubmenu = document.getElementById('learnSubmenu');

learnToggle.onclick = () => {
  learnSubmenu.classList.toggle('hidden');

  // Expand sidebar width when Learn submenu is opened
  if (!learnSubmenu.classList.contains('hidden')) {
    sidebar.classList.add('w-64');
  } else {
    sidebar.classList.remove('w-64');
    sidebar.classList.add('w-30');
  }
};