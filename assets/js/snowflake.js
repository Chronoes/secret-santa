// Snow from https://codepen.io/radum/pen/xICAB
var COUNT = 30;
var masthead;
var width;
var height;
var active = false;
var gracefulHalt = false;

var canvas = document.createElement('canvas');
var ctx = canvas.getContext('2d');

canvas.style.position = 'absolute';
canvas.style.left = canvas.style.top = '0';
canvas.style.zIndex = -9999;

function setContainerBounds() {
  const bounds = masthead.getBoundingClientRect();
  width = bounds.right;
  height = bounds.bottom;
}

var Snowflake = function () {
  this.x = 0;
  this.y = 0;
  this.vy = 0;
  this.vx = 0;
  this.r = 0;
  this.halted = false;

  this.reset();
};

Snowflake.prototype.reset = function () {
  this.x = Math.random() * width;
  this.y = Math.random() * -height;
  this.vy = 1 + Math.random() * 3;
  this.vx = 0.5 - Math.random();
  this.r = 1 + Math.random() * 2;
  this.o = 0.5 + Math.random() * 0.5;
};

var snowflakes = [];
var snowflake;

function update() {
  ctx.clearRect(0, 0, width, height);

  if (!active) return;

  for (var i = 0; i < COUNT; i++) {
    snowflake = snowflakes[i];
    if (snowflake.halted) {
      continue;
    }
    snowflake.y += snowflake.vy;
    snowflake.x += snowflake.vx;

    ctx.globalAlpha = snowflake.o;
    ctx.beginPath();
    ctx.arc(snowflake.x, snowflake.y, snowflake.r, 0, Math.PI * 2, false);
    ctx.closePath();
    ctx.fill();

    if (snowflake.y > height) {
      snowflake.halted = gracefulHalt;
      snowflake.reset();
    }
  }

  if (gracefulHalt && snowflakes.every((snowflake) => snowflake.halted)) {
    active = false;
  }
  requestAnimFrame(update);
}

function onResize() {
  setContainerBounds();
  canvas.width = width;
  canvas.height = height;
  ctx.fillStyle = '#FFF';

  var wasActive = active;
  // Disabled for mobile-size screens
  active = width > 600;

  if (!wasActive && active) requestAnimFrame(update);
}

function onBlur() {
  active = false;
}

export default function snowfall(element) {
  if (!element) {
    console.warn('Snowfall: No container found');
    return () => {};
  }
  masthead = element;
  setContainerBounds();

  gracefulHalt = false;
  if (snowflakes.length === 0) {
    for (var i = 0; i < COUNT; i++) {
      snowflake = new Snowflake();
      snowflake.reset();
      snowflakes.push(snowflake);
    }
  } else {
    for (var i = 0; i < COUNT; i++) {
      snowflake = snowflakes[i];
      snowflake.reset();
      snowflake.halted = false;
    }
  }
  onResize();
  window.addEventListener('resize', onResize, { passive: true });
  window.addEventListener('blur', onBlur, { passive: true });
  window.addEventListener('focus', onResize, { passive: true });

  masthead.appendChild(canvas);

  return () => {
    window.removeEventListener('resize', onResize);
    window.removeEventListener('blur', onBlur);
    window.removeEventListener('focus', onResize);
    gracefulHalt = true;
  };
}
