$(document).ready(function(){
	clearInputs();
	$('.img-rotation').gallery({
		autoRotation: 5000,
		duration: 500,
		listOfSlides: 'div.inner',
		switcher: 'div.nav > ul > li'
	}).find('.pause').click(function(){
		$(this).toggleClass('play');
		if(!$(this).hasClass('play')){
			$('.img-rotation').gallery('play');
		}
		else{
			$('.img-rotation').gallery('stop');
		}
		return false;
	});
	initNav();
$(document).ready(function(){
	$('.slider').gallery({
		listOfSlides: 'div.hold > ul > li',
		autoRotation: 5000,
		duration: 500,
		slideElement: 4,
		circle: false,
		disableBtn: "disabled"
	});
});
$(document).ready(function(){
	$('.text-gallery').gallery({
		listOfSlides: 'ul > li',
		effect: true,
		autoRotation: 8000,
		duration: 500,
		autoHeight: true
	});
	$('.gallery').gallery({
		listOfSlides: '.big > ul > li',
		effect: true,
		duration: 500,
		switcher: 'ul.small > li'
	});
});
	$('ul.tabs2').each(function(){
		$(this).tabs();
	});
	$('input.customRadio').customRadio();
	$('input.customCheckbox').customCheckbox();
});

function initNav(){
	$('.main-menu').each(function(){
		var hold = $(this);
		var ul = hold.find('ul');
		var a = hold.find('a');
		var time;

		ul.css({display: 'block'}).each(function(){
			$(this).css({right: 'auto', left:'100%'}).parent().find('a').removeClass('to-left');
			if($(this).offset().left + $(this).outerWidth(true) > hold.parent().offset().left + hold.parent().outerWidth(true)){
				$(this).css({right: '100%', left:'auto'}).parent().find('a').addClass('to-left');
			}
		});

		ul.css({display: 'none'});
		a.hover(function(){
			if(time) clearTimeout(time);
			ul.not($(this).parent().find('> ul')).not($(this).parent().parents('ul')).css({display: 'none'});
			$(this).parent().find('> ul').css({display: 'block'});
			return false;
		}, function(){

		});
		hold.hover(function(){
			if(time) clearTimeout(time);
		}, function(){
			time = setTimeout(function(){
				ul.css({display: 'none'});
			}, 500);
		});
	});
}

function clearInputs(){
	$('.search2 input:text').each(function(){
		var _el = $(this);
		var _val = _el.val();

		_el.bind('focus', function(){
			if (this.value == _val) {
				this.value = '';
				$(this).parent().addClass('ready');
			}
			$(this).parent().addClass('input-focus');
		}).bind('blur', function(){
			if(this.value == '') {
				this.value = _val;
				$(this).parent().removeClass('ready');
			}
			$(this).parent().removeClass('input-focus');
		});
	});
}
/**
 * jQuery gallery v2.0.6
 * Copyright (c) 2013 JetCoders
 * email: yuriy.shpak@jetcoders.com
 * www: JetCoders.com
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 **/

;(function(e){var t=function(e){e.holdWidth=e.list.parent().outerWidth();e.woh=e.elements.outerWidth(true);if(!e.direction)e.parentSize=e.holdWidth;else{e.woh=e.elements.outerHeight(true);e.parentSize=e.list.parent().height()}e.wrapHolderW=Math.ceil(e.parentSize/e.woh);if((e.wrapHolderW-1)*e.woh+e.woh/2>e.parentSize)e.wrapHolderW--;if(e.wrapHolderW==0)e.wrapHolderW=1},n=function(e){if(!e.direction)return{left:-(e.woh*e.active)};else return{top:-(e.woh*e.active)}},r=function(e){e.prevBtn.removeClass(e.disableBtn);e.nextBtn.removeClass(e.disableBtn);if(e.active==0||e.count+1==e.wrapHolderW-1)e.prevBtn.addClass(e.disableBtn);if(e.active==0&&e.count+1==1||e.count+1<=e.wrapHolderW-1)e.nextBtn.addClass(e.disableBtn);if(e.active==e.rew)e.nextBtn.addClass(e.disableBtn)},i=function(e,t,n){t.bind(e.event,function(){if(e.flag){if(e.infinite)e.flag=false;if(e._t)clearTimeout(e._t);o(e,n);if(e.autoRotation)f(e);if(typeof e.onChange=="function")e.onChange({elements:e.elements,active:e.active})}if(e.event=="click")return false})},s=function(t){t.switcher.bind(t.event,function(){if(t.flag&&!e(this).hasClass(t.activeClass)){if(t.infinite)t.flag=false;t.active=t.switcher.index(jQuery(this))*t.slideElement;if(t.infinite)t.active=t.switcher.index(jQuery(this))+t.count;if(t._t)clearTimeout(t._t);if(t.disableBtn)r(t);if(!t.effect)a(t);else u(t);if(t.autoRotation)f(t);if(typeof t.onChange=="function")t.onChange({elements:t.elements,active:t.active})}if(t.event=="click")return false})},o=function(e,t){if(!e.infinite){if(e.active==e.rew&&e.circle&&t)e.active=-e.slideElement;if(e.active==0&&e.circle&&!t)e.active=e.rew+e.slideElement;for(var i=0;i<e.slideElement;i++){if(t){if(e.active+1<=e.rew)e.active++}else{if(e.active-1>=0)e.active--}}}else{if(e.active>=e.count+e.count&&t)e.active-=e.count;if(e.active<=e.count-1&&!t)e.active+=e.count;e.list.css(n(e));if(t)e.active+=e.slideElement;else e.active-=e.slideElement}if(e.disableBtn)r(e);if(!e.effect)a(e);else u(e)},u=function(e){if(!e.IEfx&&e.IE){e.list.eq(e.last).css({opacity:0});e.list.removeClass(e.activeClass).eq(e.active).addClass(e.activeClass).css({opacity:"auto"})}else{e.list.eq(e.last).animate({opacity:0},{queue:false,easing:e.easing,duration:e.duration});e.list.removeClass(e.activeClass).eq(e.active).addClass(e.activeClass).animate({opacity:1},{queue:false,duration:e.duration,complete:function(){jQuery(this).css("opacity","auto")}})}if(e.autoHeight)e.list.parent().animate({height:e.list.eq(e.active).outerHeight()},{queue:false,duration:e.duration});if(e.switcher)e.switcher.removeClass(e.activeClass).eq(e.active).addClass(e.activeClass);e.last=e.active},a=function(e){if(!e.infinite)e.list.animate(n(e),{queue:false,easing:e.easing,duration:e.duration});else{e.list.animate(n(e),e.duration,e.easing,function(){if(e.active>=e.count+e.count)e.active-=e.count;if(e.active<=e.count-1)e.active+=e.count;e.list.css(n(e));e.flag=true})}if(e.autoHeight)e.list.parent().animate({height:e.list.children().eq(e.active).outerHeight()},{queue:false,duration:e.duration});if(e.switcher){if(!e.infinite)e.switcher.removeClass(e.activeClass).eq(e.active/e.slideElement).addClass(e.activeClass);else{e.switcher.removeClass(e.activeClass).eq(e.active-e.count).addClass(e.activeClass);e.switcher.removeClass(e.activeClass).eq(e.active-e.count-e.count).addClass(e.activeClass);e.switcher.eq(e.active).addClass(e.activeClass)}}},f=function(e){if(e._t)clearTimeout(e._t);e._t=setInterval(function(){if(e.infinite)e.flag=false;o(e,true);if(typeof e.onChange=="function")e.onChange({elements:e.elements,active:e.active})},e.autoRotation)},l=function(e){if(e.flexible&&!e.direction){t(e);if(e.elements.length*e.minWidth>e.holdWidth){e.elements.css({width:Math.floor(e.holdWidth/Math.floor(e.holdWidth/e.minWidth))});if(e.elements.outerWidth(true)>Math.floor(e.holdWidth/Math.floor(e.holdWidth/e.minWidth))){e.elements.css({width:Math.floor(e.holdWidth/Math.floor(e.holdWidth/e.minWidth))-(e.elements.outerWidth(true)-Math.floor(e.holdWidth/Math.floor(e.holdWidth/e.minWidth)))})}}else{e.active=0;e.elements.css({width:Math.floor(e.holdWidth/e.elements.length)})}}t(e);if(!e.effect){e.rew=e.count-e.wrapHolderW+1;if(e.active>e.rew)e.active=e.rew;e.list.css({position:"relative"}).css(n(e));if(e.switcher)e.switcher.removeClass(e.activeClass).eq(e.active).addClass(e.activeClass);if(e.autoHeight)e.list.parent().css({height:e.list.children().eq(e.active).outerHeight()})}else{e.rew=e.count;e.list.css({opacity:0}).removeClass(e.activeClass).eq(e.active).addClass(e.activeClass).css({opacity:1}).css("opacity","auto");if(e.switcher)e.switcher.removeClass(e.activeClass).eq(e.active).addClass(e.activeClass);if(e.autoHeight)e.list.parent().css({height:e.list.eq(e.active).outerHeight()})}if(e.disableBtn)r(e)},c=function(t){if(!t.effect){var n,i=false,s=0,u,l=false,c=e("<span></span>");c.css({position:"absolute",left:0,top:0,width:9999,height:9999,cursor:"pointer",zIndex:9999});t.list.parent().css({position:"relative"}).append(c);c.css({display:"none"});t.list.bind("mousedown touchstart",function(e){l=false;if(t._t)clearTimeout(t._t);t.list.stop();i=true;n=e.originalEvent.pageX;u=t.list.position().left;s=0;if(e.type=="mousedown")e.preventDefault()});e(document).bind("mousemove.gallery touchmove.gallery",function(e){if(n!=e.originalEvent.pageX&&i){c.css({display:"block"});s=Math.abs(e.originalEvent.pageX-n);if(n<=e.originalEvent.pageX)s*=-1;if(t.list.position().left>0&&t.active==0||t.list.position().left<-t.woh*t.rew&&t.active==t.rew){t.list.css({left:u-s/3})}else{t.list.css({left:u-s})}return false}}).bind("mouseup.gallery touchend.gallery",function(e){if(i){c.css({display:"none"});i=false;if(s>0&&Math.abs(s)<t.woh&&Math.abs(s)>20){l="left"}if(s<0&&Math.abs(s)<t.woh&&Math.abs(s)>20){l="right"}if(t.list.position().left>0){t.active=0;a(t)}if(t.list.position().left<-t.woh*t.rew){t.active=t.rew;a(t)}if(t.list.position().left>-t.woh*t.rew&&t.list.position().left<0){if(l){if(l=="right"){o(t,false)}else{o(t,true)}l=false}else{if(Math.abs(s)>20){if(s>0)t.active=Math.ceil(-1*t.list.position().left/t.woh);else t.active=-1*Math.ceil(t.list.position().left/t.woh)}else{t.active=-1*Math.round(t.list.position().left/t.woh)}a(t)}}if(t.disableBtn)r(t);if(typeof t.onChange=="function")t.onChange({elements:t.elements,active:t.active});if(t.autoRotation)f(t)}})}},h={init:function(t){return this.each(function(){var r=e(this);r.data("gallery",jQuery.extend({},p,t));var o=r.data("gallery");o.aR=o.autoRotation;o.context=r;o.list=o.context.find(o.listOfSlides);o.elements=o.list;if(o.elements.css("position")=="absolute"&&o.autoDetect)o.effect=true;o.count=o.list.index(o.list.filter(":last"));if(!o.IEfx)o.IE=!!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase());if(!o.effect)o.list=o.list.parent();else o.touch=false;if(o.switcher)o.switcher=o.context.find(o.switcher);if(o.switcher.length==0)o.switcher=false;if(o.nextBtn)o.nextBtn=o.context.find(o.nextBtn);if(o.prevBtn)o.prevBtn=o.context.find(o.prevBtn);if(o.switcher)o.active=o.switcher.index(o.switcher.filter("."+o.activeClass+":eq(0)"));else o.active=o.elements.index(o.elements.filter("."+o.activeClass+":eq(0)"));if(o.active<0)o.active=0;o.last=o.active;if(o.flexible&&!o.direction)o.minWidth=o.elements.outerWidth(true);l(o);if(o.flexible&&!o.direction){e(window).bind("resize.gallery",function(){l(o)})}o.flag=true;if(o.infinite){o.count++;o.active+=o.count;o.list.append(o.elements.clone());o.list.append(o.elements.clone());o.list.css(n(o));o.elements=o.list.children()}if(o.rew<0&&!o.effect){o.list.css({left:0});return false}if(o.nextBtn)i(o,o.nextBtn,true);if(o.prevBtn)i(o,o.prevBtn,false);if(o.switcher)s(o);if(o.autoRotation)f(o);if(o.touch)c(o)})},option:function(e,t){if(typeof t!="object")t=this.eq(0);var n=this.filter(t),r=n.data("gallery");if(!r)return this;return r[e]},destroy:function(){return this.each(function(){var t=e(this),n=t.data("gallery");e(window).unbind(".gallery");n.gallery.remove();t.removeData("gallery")})},rePosition:function(){return this.each(function(){var t=e(this),n=t.data("gallery");l(n)})},stop:function(){return this.each(function(){var t=e(this),n=t.data("gallery");n.aR=n.autoRotation;n.autoRotation=false;if(n._t)clearTimeout(n._t)})},play:function(t){return this.each(function(){var n=e(this),r=n.data("gallery");if(r._t)clearTimeout(r._t);r.autoRotation=t?t:r.aR;if(r.autoRotation)f(r)})},next:function(t){return this.each(function(){var n=e(this),i=n.data("gallery");if(t!="undefined"&&t>-1){i.active=t;if(i.disableBtn)r(i);if(!i.effect)a(i);else u(i)}else{if(i.flag){if(i.infinite)i.flag=false;if(i._t)clearTimeout(i._t);o(i,true);if(i.autoRotation)f(i);if(typeof i.onChange=="function")i.onChange({elements:i.elements,active:i.active})}}})},prev:function(){return this.each(function(){var t=e(this),n=t.data("gallery");if(n.flag){if(n.infinite)n.flag=false;if(n._t)clearTimeout(n._t);o(n,false);if(n.autoRotation)f(n);if(typeof n.onChange=="function")n.onChange({elements:n.elements,active:n.active})}})}},p={infinite:false,activeClass:"active",duration:300,slideElement:1,autoRotation:false,effect:false,listOfSlides:"ul:eq(0) > li",switcher:false,disableBtn:false,nextBtn:"a.link-next, a.btn-next, .next",prevBtn:"a.link-prev, a.btn-prev, .prev",IEfx:true,circle:true,direction:false,event:"click",autoHeight:false,easing:"easeOutQuad",flexible:false,autoDetect:true,touch:true,onChange:null};e.fn.gallery=function(t){if(h[t]){return h[t].apply(this,Array.prototype.slice.call(arguments,1))}else{if(typeof t==="object"||!t){return h.init.apply(this,arguments)}else{e.error("Method "+t+" does not exist on jQuery.gallery")}}};jQuery.easing["jswing"]=jQuery.easing["swing"];jQuery.extend(jQuery.easing,{def:"easeOutQuad",swing:function(e,t,n,r,i){return jQuery.easing[jQuery.easing.def](e,t,n,r,i)},easeOutQuad:function(e,t,n,r,i){return-r*(t/=i)*(t-2)+n},easeOutCirc:function(e,t,n,r,i){return r*Math.sqrt(1-(t=t/i-1)*t)+n}})})(jQuery);

/**
 * jQuery tabs min v1.0.0
 * Copyright (c) 2011 JetCoders
 * email: yuriy.shpak@jetcoders.com
 * www: JetCoders.com
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 **/

jQuery.fn.tabs=function(options){return new Tabs(this.get(0),options);};function Tabs(context,options){this.init(context,options);}Tabs.prototype={options:{},init:function(context,options){this.options=jQuery.extend({listOfTabs:'a.tab',active:'active',event:'click'},options||{});this.btn=jQuery(context).find(this.options.listOfTabs);this.last=this.btn.index(this.btn.filter('.'+this.options.active));if(this.last==-1)this.last=0;this.btn.removeClass(this.options.active).eq(this.last).addClass(this.options.active);var _this=this;this.btn.each(function(i){if(_this.last==i)jQuery($(this).attr('href')).show();else jQuery($(this).attr('href')).hide();});this.initEvent(this,this.btn);},initEvent:function($this,el){el.bind(this.options.event,function(){if($this.last!=el.index(jQuery(this)))$this.changeTab(el.index(jQuery(this)));return false;});},changeTab:function(ind){jQuery(this.btn.eq(this.last).attr('href')).hide();jQuery(this.btn.eq(ind).attr('href')).show();this.btn.eq(this.last).removeClass(this.options.active);this.btn.eq(ind).addClass(this.options.active);this.last=ind;}}

jQuery.fn.customSelect = function(_options) {
	var _options = jQuery.extend({
	selectStructure:'<div class="selectArea"><div class="selectIn"><div class="selectText"></div></div></div>',
	selectText:'.selectText',
	selectBtn:'.selectIn',
	selectDisabled:'.disabled',
	optStructure:'<div class="selectSub"><ul></ul></div>',
	maxHeight:false,optList:'ul'
}, _options);
	return this.each(function() {
		var select = jQuery(this);
		if(!select.hasClass('outtaHere')) {
			if(select.is(':visible')) {
				var replaced = jQuery(_options.selectStructure);
				var selectText = replaced.find(_options.selectText);
				var selectBtn = replaced.find(_options.selectBtn);
				var selectDisabled = replaced.find(_options.selectDisabled).hide();
				var optHolder = jQuery(_options.optStructure);
				var optList = optHolder.find(_options.optList);
				if(select.attr('disabled')) selectDisabled.show();
				select.find('option').each(function() {
					var selOpt = $(this);
					var _opt = jQuery('<li><a href="#">' + selOpt.html() + '</a></li>');
					if(selOpt.attr('selected')) {
						selectText.html(selOpt.html());
						_opt.addClass('selected');
					}
					_opt.children('a').click(function() {
						optList.find('li').removeClass('selected');
						select.find('option').removeAttr('selected');
						$(this).parent().addClass('selected');
						selOpt.prop('selected', 'selected');
						selectText.html(selOpt.html());
						select.change();
						optHolder.hide();
						return false;
					});
					optList.append(_opt);
				});
				replaced.width(select.outerWidth());
				replaced.insertBefore(select);
				replaced.addClass(select.attr('class'));
					optHolder.css({
						width: select.outerWidth(),
						display: 'none',
						position: 'absolute'
					});
				optHolder.addClass(select.attr('class'));
				jQuery(document.body).append(optHolder);

				var optTimer;
				replaced.hover(function() {
					if(optTimer) clearTimeout(optTimer);
				}, function() {
					optTimer = setTimeout(function() {
						optHolder.hide();
					}, 200);
				});
				optHolder.hover(function(){
					if(optTimer) clearTimeout(optTimer);
				}, function() {
					optTimer = setTimeout(function() {
						optHolder.hide();
					}, 200);
				});
				selectBtn.click(function() {
					if(optHolder.is(':visible')) {
						optHolder.hide();
					}
					else{
						optHolder.children('ul').css({height:'auto', overflow:'hidden'});
						optHolder.css({
							top: replaced.offset().top + replaced.outerHeight(),
							left: replaced.offset().left,
							display: 'block'
						});
						if(_options.maxHeight && optHolder.children('ul').height() > _options.maxHeight) optHolder.children('ul').css({height:_options.maxHeight, overflow:'auto'});
					}
					return false;
				});
				select.addClass('outtaHere');
			}
		}
	});
}

jQuery.fn.customRadio = function(_options){
	var _options = jQuery.extend({
		radioStructure: '<div></div>',
		radioDisabled: 'disabled',
		radioDefault: 'radioArea',
		radioChecked: 'radioAreaChecked'
	}, _options);
	return this.each(function(){
		var radio = jQuery(this);
		if(!radio.hasClass('outtaHere') && radio.is(':radio')){
			var replaced = jQuery(_options.radioStructure);
			replaced.addClass(radio.attr('class'));
			this._replaced = replaced;
			if(radio.is(':disabled')) {
				replaced.addClass(_options.radioDisabled);
				if(radio.is(':checked')) replaced.addClass('disabledChecked');
			}
			else if(radio.is(':checked')) replaced.addClass(_options.radioChecked);
			else replaced.addClass(_options.radioDefault);
			replaced.click(function(){
				if($(this).hasClass(_options.radioDefault)){
					radio.change();
					radio.prop('checked', 'checked');
					changeRadio(radio.get(0));
				}
			});
			radio.click(function(){
				changeRadio(this);
			});
			replaced.insertBefore(radio);
			radio.addClass('outtaHere');
		}
	});
	function changeRadio(_this){
		$('input:radio[name='+$(_this).attr("name")+']').not(_this).each(function(){
			if(this._replaced && !$(this).is(':disabled')) this._replaced.removeClass().addClass(_options.radioDefault);
		});
		_this._replaced.removeClass().addClass(_options.radioChecked);
		$(_this).trigger('change');
	}
}

jQuery.fn.customCheckbox = function(_options){
	var _options = jQuery.extend({
		checkboxStructure: '<div></div>',
		checkboxDisabled: 'disabled',
		checkboxDefault: 'checkboxArea',
		checkboxChecked: 'checkboxAreaChecked'
	}, _options);
	return this.each(function(){
		var checkbox = jQuery(this);
		if(!checkbox.hasClass('outtaHere') && checkbox.is(':checkbox')){
			var replaced = jQuery(_options.checkboxStructure);
			replaced.addClass(checkbox.attr('class'));
			this._replaced = replaced;
			if(checkbox.is(':disabled')) {
				replaced.addClass(_options.checkboxDisabled);
				if(checkbox.is(':checked')) replaced.addClass('disabledChecked');
			}
			else if(checkbox.is(':checked')) replaced.addClass(_options.checkboxChecked);
			else replaced.addClass(_options.checkboxDefault);

			replaced.click(function(){
				if(!replaced.hasClass('disabled')){
					if(checkbox.is(':checked')) checkbox.removeAttr('checked');
					else checkbox.attr('checked', 'checked');
					changeCheckbox(checkbox);
				}
			});
			checkbox.click(function(){
				changeCheckbox(checkbox);
			});
			replaced.insertBefore(checkbox);
			checkbox.addClass('outtaHere');
		}
	});
	function changeCheckbox(_this){
		if(_this.is(':checked')) _this.get(0)._replaced.removeClass().addClass(_options.checkboxChecked);
		else _this.get(0)._replaced.removeClass().addClass(_options.checkboxDefault);
		_this.trigger('change');
	}
}
