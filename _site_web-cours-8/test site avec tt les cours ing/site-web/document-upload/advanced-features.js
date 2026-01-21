// Fonctionnalités avancées pour le système d'upload
class AdvancedFeatures {
    constructor(uploadManager) {
        this.uploadManager = uploadManager;
        this.init();
    }

    init() {
        this.addBulkActions();
        this.addPreview();
        this.addDuplicateDetection();
        this.addSmartSuggestions();
    }

    // Actions groupées
    addBulkActions() {
        const actionsHTML = `
            <div class="bulk-actions" id="bulkActions" style="display: none;">
                <button class="bulk-btn" onclick="advancedFeatures.applyToAll()">
                    ✓ Appliquer la même matière à tous
                </button>
                <button class="bulk-btn" onclick="advancedFeatures.acceptAllSuggestions()">
                    🤖 Accepter toutes les suggestions IA
                </button>
                <button class="bulk-btn" onclick="advancedFeatures.clearAll()">
                    🗑️ Tout supprimer
                </button>
            </div>
        `;

        const filesList = document.getElementById('filesList');
        if (filesList && !document.getElementById('bulkActions')) {
            filesList.insertAdjacentHTML('beforebegin', actionsHTML);
        }
    }

    // Prévisualisation des fichiers
    addPreview() {
        document.addEventListener('click', (e) => {
            if (e.target.closest('.file-icon')) {
                const fileItem = e.target.closest('.file-item');
                const fileId = parseInt(fileItem.dataset.fileId);
                const fileData = this.uploadManager.selectedFiles.find(f => f.id === fileId);
                if (fileData) this.showPreview(fileData.file);
            }
        });
    }

    showPreview(file) {
        const reader = new FileReader();
        const ext = file.name.split('.').pop().toLowerCase();

        if (['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext)) {
            reader.onload = (e) => {
                this.showModal(`
                    <img src="${e.target.result}" style="max-width: 100%; border-radius: 10px;">
                `, file.name);
            };
            reader.readAsDataURL(file);
        } else if (['txt', 'md', 'js', 'py', 'java'].includes(ext)) {
            reader.onload = (e) => {
                this.showModal(`
                    <pre style="background: #1e1e1e; color: #d4d4d4; padding: 20px; border-radius: 10px; overflow: auto; max-height: 500px;">${e.target.result.substring(0, 2000)}</pre>
                `, file.name);
            };
            reader.readAsText(file);
        } else {
            UploadAnimations.showToast('Prévisualisation non disponible pour ce type de fichier', 'info');
        }
    }

    showModal(content, title) {
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
            background: rgba(0,0,0,0.8); z-index: 3000; display: flex; 
            align-items: center; justify-content: center;
        `;
        modal.innerHTML = `
            <div style="background: var(--card-bg); padding: 30px; border-radius: 20px; max-width: 90%; max-height: 90%; overflow: auto;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                    <h3 style="color: var(--primary);">${title}</h3>
                    <button onclick="this.closest('div').parentElement.remove()" style="background: #ff4757; color: white; border: none; width: 30px; height: 30px; border-radius: 50%; cursor: pointer;">×</button>
                </div>
                ${content}
            </div>
        `;
        document.body.appendChild(modal);
        modal.addEventListener('click', (e) => {
            if (e.target === modal) modal.remove();
        });
    }

    // Détection de doublons
    addDuplicateDetection() {
        const originalHandleFileSelect = this.uploadManager.handleFileSelect.bind(this.uploadManager);
        this.uploadManager.handleFileSelect = (files) => {
            const duplicates = [];
            const uniqueFiles = [];

            Array.from(files).forEach(file => {
                const exists = this.uploadManager.selectedFiles.find(f =>
                    f.file.name === file.name && f.file.size === file.size
                );
                if (exists) {
                    duplicates.push(file.name);
                } else {
                    uniqueFiles.push(file);
                }
            });

            if (duplicates.length > 0) {
                UploadAnimations.showToast(
                    `${duplicates.length} doublon(s) ignoré(s)`,
                    'warning'
                );
            }

            if (uniqueFiles.length > 0) {
                originalHandleFileSelect(uniqueFiles);
            }
        };
    }

    // Suggestions intelligentes
    addSmartSuggestions() {
        const checkFiles = () => {
            if (!this.uploadManager.selectedFiles.length) return;

            const filesWithoutSubject = this.uploadManager.selectedFiles.filter(f => !f.selectedSubject && !f.analyzing);
            const bulkActions = document.getElementById('bulkActions');

            if (bulkActions) {
                bulkActions.style.display = filesWithoutSubject.length > 0 || this.uploadManager.selectedFiles.length > 1 ? 'flex' : 'none';
            }
        };

        setInterval(checkFiles, 500);
    }

    // Appliquer la même matière à tous
    applyToAll() {
        const subjects = this.uploadManager.classifier.getAllSubjects();
        const subjectKeys = subjects.map(s => s.key);

        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
            background: rgba(0,0,0,0.8); z-index: 3000; display: flex; 
            align-items: center; justify-content: center; backdrop-filter: blur(5px);
        `;
        modal.innerHTML = `
            <div style="background: var(--card-bg); padding: 30px; border-radius: 20px; max-width: 600px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.4); animation: modalSlideIn 0.3s ease; max-height: 90vh; display: flex; flex-direction: column;">
                <h3 style="color: var(--primary); margin-bottom: 20px; font-size: 1.5em; text-align: center;">Choisir une matière pour tous les fichiers</h3>
                <div style="position: relative; margin-bottom: 20px;">
                    <input type="text" id="bulkSubjectSearch" placeholder="🔍 Rechercher une matière..." style="width: 100%; padding: 15px; border: 2px solid var(--border-light); border-radius: 12px; font-size: 1em; background: var(--bg-body); color: var(--text-main); transition: border-color 0.3s;" onfocus="this.style.borderColor='var(--primary)'" onblur="this.style.borderColor='var(--border-light)'">
                </div>
                <div id="bulkSubjectList" style="flex: 1; overflow-y: auto; display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 10px; padding: 5px;">
                    ${subjects.map(s => `
                        <div class="bulk-subject-option" data-key="${s.key}" style="padding: 15px; cursor: pointer; border-radius: 12px; background: var(--bg-body); border: 1px solid var(--border-light); display: flex; flex-direction: column; align-items: center; gap: 10px; text-align: center; transition: all 0.2s;">
                            <div style="font-size: 2.5em;">${s.icon}</div>
                            <div style="font-weight: 600; font-size: 0.9em; line-height: 1.3;">${s.name}</div>
                        </div>
                    `).join('')}
                </div>
                <button class="close-bulk-modal" style="width: 100%; padding: 15px; background: var(--bg-body); color: var(--text-main); border: 2px solid var(--border-light); border-radius: 12px; margin-top: 20px; cursor: pointer; font-weight: 600; transition: all 0.3s;">Annuler</button>
            </div>
        `;
        document.body.appendChild(modal);

        const searchInput = modal.querySelector('#bulkSubjectSearch');
        const options = modal.querySelectorAll('.bulk-subject-option');

        searchInput.addEventListener('input', () => {
            const term = searchInput.value.toLowerCase();
            options.forEach(opt => {
                opt.style.display = opt.textContent.toLowerCase().includes(term) ? 'block' : 'none';
            });
        });

        // Close button logic
        modal.querySelector('.close-bulk-modal').addEventListener('click', () => modal.remove());
        modal.querySelector('.close-bulk-modal').addEventListener('mouseover', function () { this.style.borderColor = '#ff4757'; this.style.color = '#ff4757'; });
        modal.querySelector('.close-bulk-modal').addEventListener('mouseout', function () { this.style.borderColor = 'var(--border-light)'; this.style.color = 'var(--text-main)'; });

        options.forEach(opt => {
            opt.addEventListener('mouseenter', () => {
                opt.style.borderColor = 'var(--primary)';
                opt.style.transform = 'translateY(-3px)';
                opt.style.boxShadow = '0 5px 15px rgba(0,0,0,0.1)';
            });
            opt.addEventListener('mouseleave', () => {
                opt.style.borderColor = 'var(--border-light)';
                opt.style.background = 'var(--bg-body)';
                opt.style.transform = '';
                opt.style.boxShadow = '';
            });
            opt.addEventListener('click', () => {
                const key = opt.dataset.key;
                this.uploadManager.selectedFiles.forEach(f => {
                    f.selectedSubject = key;
                });
                this.uploadManager.renderFilesList();
                this.uploadManager.updateConfirmButton();
                modal.remove();
                UploadAnimations.showToast('Matière appliquée à tous les fichiers', 'success');
            });
        });
    }

    // Accepter toutes les suggestions
    acceptAllSuggestions() {
        let count = 0;
        this.uploadManager.selectedFiles.forEach(f => {
            if (f.classification.subject && !f.selectedSubject) {
                f.selectedSubject = f.classification.subject;
                count++;
            }
        });
        this.uploadManager.renderFilesList();
        this.uploadManager.updateConfirmButton();
        UploadAnimations.showToast(`${count} suggestion(s) acceptée(s)`, 'success');
    }

    // Tout supprimer
    clearAll() {
        if (confirm('Supprimer tous les fichiers ?')) {
            this.uploadManager.selectedFiles = [];
            this.uploadManager.renderFilesList();
            this.uploadManager.updateConfirmButton();
            UploadAnimations.showToast('Tous les fichiers supprimés', 'info');
        }
    }
}

// Export
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AdvancedFeatures;
}
