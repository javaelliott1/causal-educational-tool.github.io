document.addEventListener('DOMContentLoaded', () => {
  // ===== Sidebar toggle =====
  const sidebar = document.getElementById('sidebar');
  const showBtn = document.getElementById('showSidebar');

  showBtn.addEventListener('click', () => {
    sidebar.classList.toggle('-translate-x-full');
  });

  // ===== Learn submenu toggle =====
  const learnToggle = document.getElementById('learnToggle');
  const learnSubmenu = document.getElementById('learnSubmenu');

  learnToggle.addEventListener('click', () => {
    learnSubmenu.classList.toggle('hidden');
    sidebar.classList.toggle('w-64', !learnSubmenu.classList.contains('hidden'));
    sidebar.classList.toggle('w-[140px]', learnSubmenu.classList.contains('hidden'));
  });

  // ===== Scroll-based image and paragraph highlighting =====
  const topics = document.querySelectorAll('.topic');
  const sideImage = document.getElementById('sideImage');
  const imageContainer = document.getElementById('imageContainer');
  const textContent = document.getElementById('textContent');

  if (topics.length && sideImage) {
    const images = [
      'assets/test.png',
      'assets/test2.png',
      'assets/test3.png',
      'assets/test4.png',
      'assets/test5.png'
    ];

    let currentImageIndex = 0;

    function updateHighlight() {
      let minDistance = Infinity;
      let newIndex = 0;

      topics.forEach((topic, index) => {
        const rect = topic.getBoundingClientRect();
        const distance = Math.abs(rect.top + rect.height / 2 - window.innerHeight / 2);
        if (distance < minDistance) {
          minDistance = distance;
          newIndex = index;
        }
      });

      // Highlight active paragraph
      topics.forEach((topic, index) => {
        topic.classList.toggle('active-topic', index === newIndex);
      });

      // Change image if needed
      if (newIndex !== currentImageIndex) {
        sideImage.style.opacity = 0;
        setTimeout(() => {
          sideImage.src = images[newIndex];
          sideImage.style.opacity = 1;
          currentImageIndex = newIndex;
        }, 200);
      }
    }

    window.addEventListener('scroll', updateHighlight);
    // Trigger once on load
    updateHighlight();
  }
});