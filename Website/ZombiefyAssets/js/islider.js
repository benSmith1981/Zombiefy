(function () {
  var slider_worker = function () {
    var slider = $(this);
    var slides = slider.find('.iphone .slides');
    var current_slide = 0;
    
    var slidenav = $("<ul />").appendTo(slider).addClass("slidenav");
    slides.children('li').each(function (i) {
      $("<li><a /></li>").appendTo(slidenav).children('a').attr('href', '#slide' + i).addClass((i == 0) ? "active" : "");
    });
    
    if (window.location.hash.match(/#slide([0-9]+)/)) {
      current_slide = parseInt(window.location.hash.match(/#slide([0-9]+)/)[1]);
      slider_change_slide(slides, slidenav, current_slide, 1);
    }
    
    var slider_autoslide = setInterval(function () {
      current_slide = (current_slide + 1) % slides.children('li').length;
      slider_change_slide(slides, slidenav, current_slide);
    }, 3000);
    
    slidenav.delegate("a", "click", function () {
      clearInterval(slider_autoslide);
      current_slide = slidenav.find('a').index(this);
      slider_change_slide(slides, slidenav, current_slide);
    });
    
    slider
      .find(".home-button")
      .click(function () {
        var hb = $(this);
        hb.addClass("pressed");
        setTimeout(function () {
          hb.removeClass("pressed");
        }, 300);
        
        clearInterval(slider_autoslide);
        slider_change_slide(slides, slidenav, 0);
      });
  };
  
  var slider_change_slide = function (slides, slidenav, new_slide, duration) {
    slidenav
      .find('a')
        .filter('.active')
          .removeClass('active')
          .end()
        .eq(new_slide)
          .addClass("active");
    
    slides.stop().animate({ left: - (new_slide * 250) }, { swing: 'linear', duration: duration || "medium" });
  };
  
  $(document).ready(function () {
    // Run the iSliders
    $(".islider").each(slider_worker);
  });
})();