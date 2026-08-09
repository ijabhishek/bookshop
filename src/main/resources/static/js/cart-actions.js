document.addEventListener("DOMContentLoaded", function () {
    const contextPath = document.body.getAttribute("data-context-path") || "";

    document.querySelectorAll("form[data-add-to-cart]").forEach(function (form) {
        form.addEventListener("submit", function (event) {
            event.preventDefault();
            const button = form.querySelector("button[type='submit']");
            const originalText = button ? button.textContent : "Add to Cart";
            if (button) { button.disabled = true; button.textContent = "Adding..."; }

            fetch(form.action, {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded", "X-Requested-With": "XMLHttpRequest" },
                body: new URLSearchParams(new FormData(form))
            })
            .then(async function (response) {
                const contentType = response.headers.get("content-type") || "";
                const text = await response.text();
                let data;
                if (contentType.includes("application/json")) {
                    try { data = JSON.parse(text); } catch (e) { throw new Error("The server returned invalid cart data."); }
                } else {
                    if (response.status === 401 || response.status === 403) throw new Error("Please log in as a purchaser to use the cart.");
                    throw new Error("Could not add this book to the cart.");
                }
                if (!response.ok || !data.success) throw new Error(data.message || "Could not add this book to the cart.");
                return data;
            })
            .then(function (data) {
                updateCartBadge(data.itemCount);
                showCartToast("Added to cart!");
            })
            .catch(function (err) { showCartToast(err.message || "Couldn't add to cart", true); })
            .finally(function () { if (button) { button.disabled = false; button.textContent = originalText; } });
        });
    });
});

function updateCartBadge(count) {
    const badge = document.getElementById("cart-badge");
    if (!badge) return;
    badge.textContent = count;
    badge.style.display = count > 0 ? "" : "none";
}
function showCartToast(message, isError) {
    let toast = document.getElementById("cart-toast");
    if (!toast) { toast = document.createElement("div"); toast.id = "cart-toast"; document.body.appendChild(toast); }
    toast.textContent = message;
    toast.className = "cart-toast" + (isError ? " cart-toast-error" : "") + " show";
    clearTimeout(toast._hideTimer);
    toast._hideTimer = setTimeout(function () { toast.classList.remove("show"); }, 2200);
}
