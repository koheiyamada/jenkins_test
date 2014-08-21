/*
 * placeholder: a jQuery plugin
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

(function ($) {
  $.extend($.fn, {
    placeholder: function (options) {
      var defaults = {placeholderClass: 'placeholder'};

      options = $.extend(defaults, options);

      return this.each(function () {
        var input = $(this);
        var form  = input.parents('form:first');
        var phText = input.attr('placeholder');
        var text  = input.val() || phText;

        if (phText === text) {
          input.addClass(options.placeholderClass);
        }

        if (phText) {
          if (phText !== text) {
            input.val(text);
          }

          input.focus(function () {
            clearInput();
          }).blur(function () {
            unclearInput();
          });

          input.on('change', function(){
            if (input.val() !== phText) {
              input.removeClass(options.placeholderClass);
            }
          });

          form.submit(function() {
            if (input.hasClass(options.placeholderClass)) {
              input.val('');
            }
          });

          input.blur();
        }

        function clearInput() {
          if (input.val() === phText) {
            input.val('');
          }

          input.removeClass(options.placeholderClass);
        }

        function unclearInput() {
          if (input.val() === '') {
            input.addClass(options.placeholderClass).val(phText);
          }
        }
      });
    }
  });
})(jQuery);

jQuery(document).ready(function ($) {
  $('[placeholder]').placeholder();
});