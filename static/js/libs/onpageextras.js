/* Google Analytics */
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-33544644-1']);
_gaq.push(['_setLocalRemoteServerMode']);
_gaq.push(['_trackPageview']);
(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

/* User Voice */
var uvOptions = {};
(function() {
    var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
    uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/llV0NkdnAJ3O0VYKTO0XEA.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
})();


$(document).ready(function () {
    /* Placeholder replacer */
    $("input").each(function() {
        if ($(this).val() === "" && $(this).attr("placeholder") !== "") {
            $(this).css("color", "grey");
            $(this).val($(this).attr("placeholder"));
            $(this).focus(function() {
                if ($(this).val() === $(this).attr("placeholder")) {
                    $(this).css("color", "black");
                    $(this).val("");
                }
            });
            $(this).blur(function() {
                if ($(this).val() === "") {
                    $(this).css("color", "grey");
                    $(this).val($(this).attr("placeholder"));
                }
            });
        }
    });
    /* Focus search box on load */
    $('#searchbox').focus();
});