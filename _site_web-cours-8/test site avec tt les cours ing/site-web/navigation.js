// Navigation améliorée
document.addEventListener('DOMContentLoaded', () => {
    // Gestion du bouton retour en haut
    const scrollBtn = document.querySelector('.scroll-top-btn');
    if (scrollBtn) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 300) {
                scrollBtn.classList.add('visible');
            } else {
                scrollBtn.classList.remove('visible');
            }
        });
    }

    // Raccourcis clavier
    document.addEventListener('keydown', (e) => {
        // Alt + Flèche gauche : Retour
        if (e.altKey && e.key === 'ArrowLeft') {
            e.preventDefault();
            window.history.back();
        }

        // Alt + Flèche droite : Suivant
        if (e.altKey && e.key === 'ArrowRight') {
            e.preventDefault();
            window.history.forward();
        }

        // Alt + Flèche haut : Haut de page
        if (e.altKey && e.key === 'ArrowUp') {
            e.preventDefault();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    });

    // --- Gestion du Zoom ---
    let currentZoom = parseFloat(localStorage.getItem('siteZoom')) || 1.0;

    function applyZoom(zoom) {
        document.body.style.fontSize = (zoom * 18) + 'px'; // Base 18px
        localStorage.setItem('siteZoom', zoom);
        const zoomResetBtn = document.getElementById('zoomReset');
        if (zoomResetBtn) {
            zoomResetBtn.innerText = Math.round(zoom * 100) + '%';
        }
    }

    // Appliquer au chargement
    applyZoom(currentZoom);

    // Injection dynamique des boutons si absent (pour toutes les pages)
    const navBar = document.querySelector('.semester-nav');
    if (navBar && !document.querySelector('.nav-right')) {
        const navRight = document.createElement('div');
        navRight.className = 'nav-right';
        navRight.innerHTML = `
            <button class="nav-action-btn zoom-btn" id="zoomOut" title="Dézoomer">A-</button>
            <button class="nav-action-btn zoom-btn" id="zoomReset" title="Réinitialiser">100%</button>
            <button class="nav-action-btn zoom-btn" id="zoomIn" title="Zoomer">A+</button>
        `;
        navBar.appendChild(navRight);
    }

    // Attacher les événements (qu'ils soient injectés ou déjà présents)
    const btnIn = document.getElementById('zoomIn');
    const btnOut = document.getElementById('zoomOut');
    const btnReset = document.getElementById('zoomReset');

    if (btnIn) btnIn.onclick = () => {
        currentZoom = Math.min(2.0, currentZoom + 0.1);
        applyZoom(currentZoom);
    };
    if (btnOut) btnOut.onclick = () => {
        currentZoom = Math.max(0.7, currentZoom - 0.1);
        applyZoom(currentZoom);
    };
    if (btnReset) btnReset.onclick = () => {
        currentZoom = 1.0;
        applyZoom(currentZoom);
    };
});
