function oiq_addPageMfg(s){ if(!window.oiq_pMfg) {window.oiq_pMfg = new Array();} window.oiq_pMfg.push(s); }
function oiq_addPageBrand(s){ if(!window.oiq_pMfg) {window.oiq_pMfg = new Array();} window.oiq_pMfg.push(s); }
function oiq_addPageDT(s) { if(!window.oiq_pDT) {window.oiq_pDT = new Array();} window.oiq_pDT.push(s); }
function oiq_addPageCat(s) { if(!window.oiq_pDT) {window.oiq_pDT = new Array();} window.oiq_pDT.push(s); }
function oiq_addPageProduct(s){ window.oiq_pProduct = s; }
function oiq_addPageSource(s) { window.oiq_pSource = s; }
function oiq_addPageLifecycle(s) { window.oiq_pSource = s; }
function oiq_addUserId(s) { window.oiq_pUser = s; }

function oiq_is (req) {
	setTimeout(function() { 
		var h=document.getElementsByTagName("head").item(0);
		var s=document.createElement("script");
		s.setAttribute("type","text/javascript");
		s.setAttribute("src",req);
		h.appendChild(s);
	},500);
}

function oiq_doTag() {
    setTimeout(function(){
		var t = new Array();
        if(!window.oiq_pMfg && !window.oiq_pDT && !window.oiq_pProduct) {
			t.push('f|"'+encodeURIComponent(document.title)+'"');
        }else{
            var i;
			if (window.oiq_pMfg)   { for(i=0; i < window.oiq_pMfg.length; i++) { t.push('m|"'+encodeURIComponent(window.oiq_pMfg[i])+'"')}}
			if (window.oiq_pDT)    { for(i=0; i < window.oiq_pDT.length; i++) { t.push('d|"'+encodeURIComponent(window.oiq_pDT[i])+'"')}}
			if (window.oiq_pProduct) t.push('p|"'+encodeURIComponent(window.oiq_pProduct)+'"');
        }
		var req='http://px.owneriq.net/j/'+'?pt=cake'+'&t='+encodeURI(t.join());
        if (window.oiq_pSource) req+='&s='+window.oiq_pSource;
        oiq_is(req);

	if (window.oiq_pUser) {
		var oiq_user_img = new Image();
		oiq_user_img.src = "http://px.owneriq.net/euid?pt=cake&uid="+encodeURIComponent(window.oiq_pUser);
	}

    },1000);
}

function oiq_onclick(m,d,p,s,o) {
	if (!m && !d && !p) return true;
	window.oiq_img_loaded = false;
	var t = new Array();
	if (m) t.push('m|"'+encodeURIComponent(m)+'"');
	if (d) t.push('d|"'+encodeURIComponent(d)+'"');
	if (p) t.push('p|"'+encodeURIComponent(p)+'"');

	var req='http://px.owneriq.net/j/'+'?pt=cake'+'&t='+encodeURI(t.join());
	if (s) req+='&s='+s;
	
	if (o && o.href) { 		oiq_is(req);
		if (o.target && o.target!='_self' && o.target!='_top') {
			return true;
		} else {
			var oiq_int_2 = setInterval(function() { if (window.oiq_img_loaded == true) { clearInterval(oiq_int_2); oiq_int_2 = false; window.location.href = o.href; }}, 75);
			setTimeout(function() { if (oiq_int_2) { window.location.href = o.href; }},2000);
			return false;
		}
	}
	return true;
}