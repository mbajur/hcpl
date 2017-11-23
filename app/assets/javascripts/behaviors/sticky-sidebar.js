var initSidebar = function() {
  if (window.sidebar !== undefined) { window.sidebar.destroy() }

  window.sidebar = new StickySidebar('.main-sidebar', {
    topSpacing: 0,
    bottomSpacing: 20,
    containerSelector: '.main',
    innerWrapperSelector: '.main-sidebar__inner',
    stickyClass: 'main-sidebar--affixed'
  })
}

document.addEventListener("turbolinks:load", function() {
  var $sidebar = $('[data-js-sticky-sidebar]')
  if (!$sidebar.length) return

  setTimeout(function() {
    initSidebar()
  }, 300)
})
