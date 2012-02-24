function toggleStealthClassesOnBody() {
  el = $$('body')[0]

  if (el.hasClassName('stealth_on')) 
  {
    el.removeClassName('stealth_on');
    el.addClassName('stealth_off');
  } else {
    el.removeClassName('stealth_off');
    el.addClassName('stealth_on');
  }
}
