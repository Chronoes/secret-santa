// Snow from https://codepen.io/radum/pen/xICAB
var MAX_COUNT = 45;
var ANIMATED_MAX_COUNT = 30;
var masthead;
var width;
var height;
var animationActive = false;
var gracefulHalt = false;
var staticBgActive = false;

var canvas = document.createElement('canvas');
var canvasCtx = canvas.getContext('2d');

canvas.style.position = 'absolute';
canvas.style.left = canvas.style.top = '0';
canvas.style.zIndex = -9999;

function setContainerBounds() {
  const bounds = masthead.getBoundingClientRect();
  width = bounds.right;
  height = bounds.bottom;
  canvas.width = width;
  canvas.height = height;
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
var animatedFlakes = [];

function drawSnowflakeOnCanvas(ctx, snowflake) {
  ctx.globalAlpha = snowflake.o;
  ctx.beginPath();
  ctx.arc(snowflake.x, snowflake.y, snowflake.r, 0, Math.PI * 2, false);
  ctx.closePath();
  ctx.fill();
}

function update() {
  canvasCtx.clearRect(0, 0, width, height);

  if (!animationActive) return;

  canvasCtx.fillStyle = '#FFF';
  animatedFlakes.forEach((snowflake) => {
    if (snowflake.halted) {
      return;
    }

    snowflake.y += snowflake.vy;
    snowflake.x += snowflake.vx;

    drawSnowflakeOnCanvas(canvasCtx, snowflake);

    if (snowflake.y > height) {
      snowflake.halted = gracefulHalt;
      snowflake.reset();
    }
  });

  if (gracefulHalt && animatedFlakes.every((snowflake) => snowflake.halted)) {
    animationActive = false;
  }
  requestAnimFrame(update);
}

function useAnimatedBackground() {
  // return width && width > 600;
  // Use only static background for now
  return false;
}

function createStaticBackground() {
  staticBgActive = true;
  canvasCtx.fillStyle = '#FFF';
  var toRender = width > 600 ? snowflakes : snowflakes.slice(0, Math.floor(snowflakes.length / 2));
  toRender.forEach((snowflake) => {
    snowflake.reset();
    snowflake.y = Math.abs(snowflake.y);
    drawSnowflakeOnCanvas(canvasCtx, snowflake);
  });
}

function runAnimations() {
  var wasActive = animationActive;
  animationActive = useAnimatedBackground();

  if (!wasActive && animationActive) {
    if (staticBgActive) {
      animatedFlakes.forEach((snowflake) => {
        snowflake.reset();
      });
    }
    requestAnimFrame(update);
  }

  return animationActive;
}

function onResize() {
  setContainerBounds();

  if (!runAnimations()) {
    createStaticBackground();
  }
}

function onBlur() {
  animationActive = false;
}

function onFocus() {
  runAnimations();
}

function resetVariables() {
  setContainerBounds();
  animationActive = false;
  staticBgActive = false;
  gracefulHalt = false;
  snowflakes = [];
  for (var i = 0; i < MAX_COUNT; i++) {
    var snowflake = new Snowflake();
    snowflake.reset();
    snowflakes.push(snowflake);
  }
  animatedFlakes = snowflakes.slice(0, Math.floor(MAX_COUNT * ANIMATED_MAX_COUNT));
}

export default function snowfall(element) {
  if (!element) {
    console.warn('Snowfall: No container found');
    return () => {};
  }
  masthead = element;
  resetVariables();
  onResize();
  window.addEventListener('resize', onResize, { passive: true });
  window.addEventListener('blur', onBlur, { passive: true });
  window.addEventListener('focus', onFocus, { passive: true });

  masthead.appendChild(canvas);

  return () => {
    window.removeEventListener('resize', onResize);
    window.removeEventListener('blur', onBlur);
    window.removeEventListener('focus', onFocus);
    gracefulHalt = true;
  };
}
