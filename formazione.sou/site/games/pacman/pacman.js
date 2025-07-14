const canvas = document.getElementById("game");
const ctx = canvas.getContext("2d");

let x = 50;
let y = 50;
let dx = 2;
let dy = 0;

function drawPacman() {
  ctx.beginPath();
  ctx.arc(x, y, 20, 0.2 * Math.PI, 1.8 * Math.PI);
  ctx.lineTo(x, y);
  ctx.fillStyle = "yellow";
  ctx.fill();
  ctx.closePath();
}

function draw() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawPacman();

  x += dx;
  y += dy;

  if (x > canvas.width || x < 0) dx = -dx;
  if (y > canvas.height || y < 0) dy = -dy;

  requestAnimationFrame(draw);
}

document.addEventListener("keydown", (e) => {
  if (e.key === "ArrowRight") { dx = 2; dy = 0; }
  if (e.key === "ArrowLeft")  { dx = -2; dy = 0; }
  if (e.key === "ArrowUp")    { dx = 0; dy = -2; }
  if (e.key === "ArrowDown")  { dx = 0; dy = 2; }
});

draw();
