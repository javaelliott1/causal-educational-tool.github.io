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

  if (topics.length && sideImage) {

    // ✅ PRELOAD IMAGES FROM data-image ATTRIBUTES
    const imageSet = new Set();
    topics.forEach(topic => {
      const img = topic.getAttribute('data-image');
      if (img) imageSet.add(img);
    });

    imageSet.forEach(src => {
      const img = new Image();
      img.src = src;
    });

    let currentImage = sideImage.getAttribute('src');

    function updateHighlight() {
      let minDistance = Infinity;
      let activeTopic = null;

      topics.forEach((topic) => {
        const rect = topic.getBoundingClientRect();
        const distance = Math.abs(rect.top + rect.height / 2 - window.innerHeight / 2);

        if (distance < minDistance) {
          minDistance = distance;
          activeTopic = topic;
        }
      });

      // Highlight active paragraph
      topics.forEach((topic) => {
        topic.classList.toggle('active-topic', topic === activeTopic);
      });

      // Change image if needed
      if (activeTopic) {
        const newImage = activeTopic.getAttribute('data-image');

        if (newImage && currentImage !== newImage) {
          sideImage.style.opacity = 0;

          setTimeout(() => {
            sideImage.src = newImage;
            sideImage.style.opacity = 1;
            currentImage = newImage;
          }, 200);
        }
      }
    }

    window.addEventListener('scroll', updateHighlight);

    // Trigger once on load
    updateHighlight();
  }
});