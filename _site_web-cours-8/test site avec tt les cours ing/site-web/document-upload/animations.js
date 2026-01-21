// Animations et améliorations UX pour le système d'upload
class UploadAnimations {
    constructor() {
        this.init();
    }

    init() {
        this.addPulseEffect();
        this.addTooltips();
        this.addKeyboardShortcuts();
    }

    // Effet de pulsation sur le bouton d'upload pour attirer l'attention
    addPulseEffect() {
        const style = document.createElement('style');
        style.textContent = `
            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.05); }
            }
            
            .nav-link.upload-btn.pulse {
                animation: pulse 2s infinite;
            }
            
            .upload-zone.highlight {
                animation: highlight 1s ease;
            }
            
            @keyframes highlight {
                0%, 100% { background: var(--bg-body); }
                50% { background: rgba(102, 126, 234, 0.1); }
            }
            
            .file-item.new {
                animation: slideInUp 0.3s ease;
            }
            
            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .confidence-indicator.high {
                animation: checkmark 0.5s ease;
            }
            
            @keyframes checkmark {
                0% { transform: scale(0); }
                50% { transform: scale(1.2); }
                100% { transform: scale(1); }
            }
        `;
        document.head.appendChild(style);
    }

    // Ajoute des tooltips informatifs
    addTooltips() {
        const style = document.createElement('style');
        style.textContent = `
            [data-tooltip] {
                position: relative;
                cursor: help;
            }
            
            [data-tooltip]:hover::before {
                content: attr(data-tooltip);
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translateX(-50%);
                padding: 8px 12px;
                background: rgba(0, 0, 0, 0.9);
                color: white;
                border-radius: 6px;
                font-size: 0.85em;
                white-space: nowrap;
                z-index: 1000;
                margin-bottom: 5px;
                animation: tooltipFadeIn 0.2s ease;
            }
            
            [data-tooltip]:hover::after {
                content: '';
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translateX(-50%);
                border: 5px solid transparent;
                border-top-color: rgba(0, 0, 0, 0.9);
                margin-bottom: -5px;
            }
            
            @keyframes tooltipFadeIn {
                from { opacity: 0; transform: translateX(-50%) translateY(5px); }
                to { opacity: 1; transform: translateX(-50%) translateY(0); }
            }
        `;
        document.head.appendChild(style);
    }

    // Raccourcis clavier
    addKeyboardShortcuts() {
        document.addEventListener('keydown', (e) => {
            // Ctrl/Cmd + U pour ouvrir l'upload
            if ((e.ctrlKey || e.metaKey) && e.key === 'u') {
                e.preventDefault();
                if (typeof uploadManager !== 'undefined') {
                    uploadManager.openModal();
                }
            }
            
            // Échap pour fermer la modale
            if (e.key === 'Escape') {
                const modal = document.getElementById('uploadModalOverlay');
                if (modal && modal.classList.contains('active')) {
                    if (typeof uploadManager !== 'undefined') {
                        uploadManager.closeModal();
                    }
                }
            }
        });
    }

    // Effet de confetti pour célébrer l'upload réussi
    static showConfetti() {
        const colors = ['#667eea', '#764ba2', '#4CAF50', '#FF9800', '#2196F3'];
        const confettiCount = 50;
        
        for (let i = 0; i < confettiCount; i++) {
            setTimeout(() => {
                const confetti = document.createElement('div');
                confetti.style.cssText = `
                    position: fixed;
                    width: 10px;
                    height: 10px;
                    background: ${colors[Math.floor(Math.random() * colors.length)]};
                    top: -10px;
                    left: ${Math.random() * 100}%;
                    border-radius: 50%;
                    z-index: 9999;
                    pointer-events: none;
                    animation: confettiFall ${2 + Math.random() * 2}s linear forwards;
                `;
                
                document.body.appendChild(confetti);
                
                setTimeout(() => confetti.remove(), 4000);
            }, i * 30);
        }
        
        // Ajoute l'animation CSS si elle n'existe pas
        if (!document.getElementById('confetti-animation')) {
            const style = document.createElement('style');
            style.id = 'confetti-animation';
            style.textContent = `
                @keyframes confettiFall {
                    to {
                        transform: translateY(100vh) rotate(360deg);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // Effet de progression visuelle
    static updateProgressWithAnimation(percentage, element) {
        const fill = element.querySelector('.progress-fill');
        if (fill) {
            fill.style.transition = 'width 0.3s ease';
            fill.style.width = percentage + '%';
        }
    }

    // Shake animation pour les erreurs
    static shakeElement(element) {
        element.style.animation = 'shake 0.5s';
        setTimeout(() => {
            element.style.animation = '';
        }, 500);
        
        if (!document.getElementById('shake-animation')) {
            const style = document.createElement('style');
            style.id = 'shake-animation';
            style.textContent = `
                @keyframes shake {
                    0%, 100% { transform: translateX(0); }
                    10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                    20%, 40%, 60%, 80% { transform: translateX(5px); }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // Effet de succès sur un élément
    static successPulse(element) {
        element.style.animation = 'successPulse 0.6s';
        setTimeout(() => {
            element.style.animation = '';
        }, 600);
        
        if (!document.getElementById('success-pulse-animation')) {
            const style = document.createElement('style');
            style.id = 'success-pulse-animation';
            style.textContent = `
                @keyframes successPulse {
                    0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(76, 175, 80, 0.7); }
                    50% { transform: scale(1.05); box-shadow: 0 0 0 10px rgba(76, 175, 80, 0); }
                    100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(76, 175, 80, 0); }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // Notification toast personnalisée
    static showToast(message, type = 'info', duration = 3000) {
        const colors = {
            success: 'linear-gradient(135deg, #4CAF50, #45a049)',
            error: 'linear-gradient(135deg, #ff4757, #ff3838)',
            warning: 'linear-gradient(135deg, #FF9800, #F57C00)',
            info: 'linear-gradient(135deg, #2196F3, #1976D2)'
        };
        
        const icons = {
            success: '✓',
            error: '✗',
            warning: '⚠',
            info: 'ℹ'
        };
        
        const toast = document.createElement('div');
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${colors[type]};
            color: white;
            padding: 15px 25px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            z-index: 10000;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideInRight 0.3s ease;
            max-width: 400px;
        `;
        
        toast.innerHTML = `
            <span style="font-size: 1.5em;">${icons[type]}</span>
            <span>${message}</span>
        `;
        
        document.body.appendChild(toast);
        
        setTimeout(() => {
            toast.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    // Effet de chargement sur un bouton
    static setButtonLoading(button, loading = true) {
        if (loading) {
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = '<span style="display: inline-block; animation: spin 1s linear infinite;">⏳</span> Chargement...';
            button.disabled = true;
            
            if (!document.getElementById('spin-animation')) {
                const style = document.createElement('style');
                style.id = 'spin-animation';
                style.textContent = `
                    @keyframes spin {
                        from { transform: rotate(0deg); }
                        to { transform: rotate(360deg); }
                    }
                `;
                document.head.appendChild(style);
            }
        } else {
            button.innerHTML = button.dataset.originalText || button.innerHTML;
            button.disabled = false;
        }
    }
}

// Initialisation automatique
document.addEventListener('DOMContentLoaded', () => {
    new UploadAnimations();
    
    // Ajoute un effet de pulsation au bouton d'upload après 5 secondes
    // pour attirer l'attention de l'utilisateur
    setTimeout(() => {
        const uploadBtn = document.querySelector('.nav-link.upload-btn');
        if (uploadBtn && !sessionStorage.getItem('uploadBtnSeen')) {
            uploadBtn.classList.add('pulse');
            
            // Retire l'effet après le premier clic
            uploadBtn.addEventListener('click', () => {
                uploadBtn.classList.remove('pulse');
                sessionStorage.setItem('uploadBtnSeen', 'true');
            }, { once: true });
        }
    }, 5000);
});

// Export pour utilisation
if (typeof module !== 'undefined' && module.exports) {
    module.exports = UploadAnimations;
}
