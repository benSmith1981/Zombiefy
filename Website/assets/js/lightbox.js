(function () {
  var body_width_to_video = function (width) {
    if (width < 480) {
      width = 260;
    } else if (width < 768) {
      width = 340;
    } else if (width < 960) {
      width = 700;
    } else {
      width = 800;
    }
    height = width * 450/800;
    return [width, height];
  };
  
  var display_lightbox = function () {
    if (window.location.hash != "#open_lightbox") {
        return;
    }
    
    dimensions = body_width_to_video(parseInt($("body").width()));
    width = dimensions[0];
    height = dimensions[1];
    
    var lightbox = $("#lightbox");
    
    if (width > 380) {
      lightbox.css({ top: '50%', marginTop: - (30 + (height / 2)) });
    }
    var hide_lightbox = function () {
      $("#lightbox")
        .find('iframe')
          .remove()
          .end()
        .fadeOut();
      $("#darkbox").fadeOut();
      window.location.hash = "#";
    };
    lightbox
      .children('.box')
        .css({ 'width': width, 'height': height })
        .append('<iframe src="http://player.vimeo.com/video/32001208?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1" width="' + width + '" height="' + height + '" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>')
        .end()
      .fadeIn()
      .find('iframe')
        .click()
        .end()
      .find('.close')
        .click(hide_lightbox);
      $("#darkbox").fadeIn().click(hide_lightbox);
  };
  
  var display_inline_video = function () {
    dimensions = body_width_to_video(parseInt($("body").width()));
    width = dimensions[0];
    height = dimensions[1];
    
    $("#main .launch-video.button-3state").replaceWith('<iframe src="http://player.vimeo.com/video/32001208?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1" width="' + width + '" height="' + height + '" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen style="margin-top: 15px;"></iframe>');
  };
  
  $(document).ready(function () {
    if (parseInt($("body").width()) > 767) {
      // Display lightbox if already at #lightbox, else wait for it
      display_lightbox();
      $(window).bind('hashchange', display_lightbox);
    } else {
      display_inline_video();
    }
  });
})();