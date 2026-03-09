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

  // Instead of setting style.width, toggle a class
  sidebar.classList.toggle('w-64', !learnSubmenu.classList.contains('hidden'));
  sidebar.classList.toggle('w-[140px]', learnSubmenu.classList.contains('hidden'));
});

// ===== Scroll-based image switching for side pages (optional) =====
const topics = document.querySelectorAll('.topic');
const sideImage = document.getElementById('sideImage');
const imageContainer = document.getElementById('imageContainer');
const textContent = document.getElementById('textContent');

if (topics.length && sideImage) { // Only run on side pages
  const images = [
    'assets/test.png',
    'assets/test2.png',
    'assets/test3.png',
    'assets/test4.png',
    'assets/test5.png'
  ];

  let currentImageIndex = 0;

  window.addEventListener('scroll', () => {
    let newIndex = 0;
    topics.forEach((topic, index) => {
      const rect = topic.getBoundingClientRect();
      if (rect.top < window.innerHeight / 2) {
        newIndex = index;
      }
    });

    if (newIndex !== currentImageIndex) {
      sideImage.style.opacity = 0;
      setTimeout(() => {
        sideImage.src = images[newIndex];
        sideImage.style.opacity = 1;
        currentImageIndex = newIndex;
      }, 200);
    }

    // Expand/shrink image width based on first topic
    const firstTopicRect = topics[0].getBoundingClientRect();
    if (firstTopicRect.top < window.innerHeight / 2) {
      imageContainer.classList.remove('md:w-1/3');
      imageContainer.classList.add('md:w-1/2');

      textContent.classList.remove('md:w-2/3');
      textContent.classList.add('md:w-1/2');
    } else {
      imageContainer.classList.remove('md:w-1/2');
      imageContainer.classList.add('md:w-1/3');

      textContent.classList.remove('md:w-1/2');
      textContent.classList.add('md:w-2/3');
    }
  });
}