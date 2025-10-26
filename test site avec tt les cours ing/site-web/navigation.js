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
            window.scrollTo({top: 0, behavior: 'smooth'});
        }
    });
});
