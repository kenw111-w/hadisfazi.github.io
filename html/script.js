const list = document.getElementById("list");
const thumb = document.getElementById("thumb");
const count = document.getElementById("count");

function render({ items, index }) {
  list.innerHTML = "";
  items.forEach((name, k) => {
    const li = document.createElement("li");
    li.innerHTML = '<span></span><span class="chev">&raquo;</span>';
    li.firstChild.textContent = name;
    if (k + 1 === index) li.classList.add("sel");
    list.appendChild(li);
  });
  count.textContent = `${index}/${items.length}`;
  const h = 100 / items.length;
  thumb.style.height = h + "%";
  thumb.style.top = (index - 1) * h + "%";
}

window.addEventListener("message", (e) => {
  const data = typeof e.data === "string" ? JSON.parse(e.data) : e.data;
  if (data && data.items) render(data);
});
