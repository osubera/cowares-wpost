// javascript for vba section 
// Copyright (C) 2001 Tomizono

function addSpan(o) {
  var s; var t;
  s = document.createElement("span");
  t = document.createTextNode(" [ click to expand ]");
  o.appendChild(s);
  s.appendChild(t);
}

function killSpan(o) {
  var s; var i;
  s = o.getElementsByTagName("span");
  for(i=0;i<s.length;i++) {
    o.removeChild(s[i]);
  }
}

function smr1(o) {
  smr1a(o,0);
}

function smr1a(o,a) {
  var t1;
  t1 = o.nextSibling;
  switch( t1.style.display ) {
      case "none" :
        if(a!=2) {
          t1.style.display = "block";
          killSpan(o);
        }
        break;
      default :
        if(a!=1) {
          t1.style.display = "none";
          addSpan(o);
        }
  }
}

function smr2(tag,a) {
  var t1; var i;
  t1 = document.getElementsByTagName(tag);
  for(i=0;i<t1.length;i++) {
    smr1a(t1[i],a);
  }
}

function smr3() {
  smr2("h2",2);
  smr2("h3",2);
}

function smr4() {
  smr2("h2",1);
  smr2("h3",1);
}

function smr3g() {
  smr3();
  smr1a(document.getElementsByTagName("h2")[1],1);
}
