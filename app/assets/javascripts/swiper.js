// DOMを読み込んだ後に、スワイパーを作動させる
$(function() {
    new Swiper('.swiper-container', {
        pagination: {
            el: '.swiper-pagination',
        },
    })
});
