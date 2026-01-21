// Gestionnaire de l'interface d'upload de documents
class DocumentUploadManager {
    constructor() {
        this.classifier = new DocumentClassifier();
        this.selectedFiles = [];
        this.init();
    }

    init() {
        this.createModal();
        this.attachEventListeners();
    }

    createModal() {
        const modalHTML = `
            <div id="uploadModalOverlay" class="upload-modal-overlay">
                <div class="upload-modal">
                    <div class="upload-modal-header">
                        <h2>📤 Ajouter des documents</h2>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <div id="uploadStats" style="font-size: 0.9em; color: #999;"></div>
                            <button class="upload-close-btn" onclick="uploadManager.closeModal()">×</button>
                        </div>
                    </div>
                    
                    <div class="upload-zone" id="uploadZone">
                        <div class="upload-zone-icon">📁</div>
                        <div class="upload-zone-text">Cliquez ou glissez vos fichiers ici</div>
                        <div class="upload-zone-hint">PDF, Word, PowerPoint, Excel, Images, etc.</div>
                        <input type="file" id="fileInput" multiple accept="*/*">
                    </div>

                    <div class="files-list" id="filesList"></div>

                    <div class="upload-actions">
                        <button class="upload-btn upload-btn-secondary" onclick="uploadManager.closeModal()">
                            Annuler
                        </button>
                        <button class="upload-btn upload-btn-primary" id="confirmUploadBtn" onclick="uploadManager.confirmUpload()" disabled>
                            Confirmer et Classer
                        </button>
                    </div>

                    <div class="upload-progress" id="uploadProgress">
                        <div class="progress-bar">
                            <div class="progress-fill" id="progressFill"></div>
                        </div>
                        <div class="upload-status" id="uploadStatus"></div>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHTML);
    }

    attachEventListeners() {
        const uploadZone = document.getElementById('uploadZone');
        const fileInput = document.getElementById('fileInput');

        // Click sur la zone d'upload
        uploadZone.addEventListener('click', () => fileInput.click());

        // Sélection de fichiers
        fileInput.addEventListener('change', (e) => this.handleFileSelect(e.target.files));

        // Drag & Drop
        uploadZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadZone.classList.add('dragover');
        });

        uploadZone.addEventListener('dragleave', () => {
            uploadZone.classList.remove('dragover');
        });

        uploadZone.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadZone.classList.remove('dragover');
            this.handleFileSelect(e.dataTransfer.files);
        });

        // Fermer les dropdowns au clic à l'extérieur (Global listener)
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.searchable-select')) {
                document.querySelectorAll('.subject-dropdown').forEach(d => d.style.display = 'none');
            }
        });
    }

    openModal() {
        document.getElementById('uploadModalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    closeModal() {
        document.getElementById('uploadModalOverlay').classList.remove('active');
        document.body.style.overflow = '';
        this.resetUpload();
    }

    resetUpload() {
        this.selectedFiles = [];
        document.getElementById('filesList').innerHTML = '';
        document.getElementById('fileInput').value = '';
        document.getElementById('confirmUploadBtn').disabled = true;
        document.getElementById('uploadProgress').style.display = 'none';
    }

    handleFileSelect(files) {
        Array.from(files).forEach(async (file) => {
            const fileId = Date.now() + Math.random();

            // Classification initiale par nom
            const nameClassification = this.classifier.classify(file.name);

            // Ajout du fichier avec classification initiale
            const fileData = {
                id: fileId,
                file: file,
                classification: nameClassification,
                selectedSubject: nameClassification.subject,
                analyzing: true
            };

            this.selectedFiles.push(fileData);
            this.renderFilesList();
            this.updateConfirmButton();

            // Analyse du contenu en arrière-plan
            try {
                const contentClassification = await this.classifier.classifyWithContent(file);

                // Mise à jour avec l'analyse du contenu
                const fileIndex = this.selectedFiles.findIndex(f => f.id === fileId);
                if (fileIndex !== -1) {
                    this.selectedFiles[fileIndex].classification = contentClassification;
                    this.selectedFiles[fileIndex].selectedSubject = contentClassification.subject || this.selectedFiles[fileIndex].selectedSubject;
                    this.selectedFiles[fileIndex].analyzing = false;
                    this.updateFileItem(fileId);
                    this.updateConfirmButton();
                }
            } catch (error) {
                console.warn('Erreur lors de l\'analyse du contenu:', error);
                const fileIndex = this.selectedFiles.findIndex(f => f.id === fileId);
                if (fileIndex !== -1) {
                    this.selectedFiles[fileIndex].analyzing = false;
                    this.renderFilesList();
                }
            }
        });
    }

    renderFilesList() {
        const filesList = document.getElementById('filesList');

        // Mise à jour des stats
        this.updateStats();

        filesList.innerHTML = this.selectedFiles.map(fileData => this.renderFileItemHTML(fileData)).join('');

        // Attacher les événements pour les inputs de recherche
        this.attachSearchableSelectEvents();
    }

    updateFileItem(fileId) {
        const fileData = this.selectedFiles.find(f => f.id === fileId);
        if (!fileData) return;

        const oldItem = document.querySelector(`.file-item[data-file-id="${fileId}"]`);
        if (oldItem) {
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = this.renderFileItemHTML(fileData);
            const newItem = tempDiv.firstElementChild;

            oldItem.replaceWith(newItem);

            this.attachSearchableSelectEvents();
            this.updateStats();
        }
    }

    updateStats() {
        const stats = document.getElementById('uploadStats');
        if (stats) {
            const total = this.selectedFiles.length;
            const withSubject = this.selectedFiles.filter(f => f.selectedSubject).length;
            const analyzing = this.selectedFiles.filter(f => f.analyzing).length;
            stats.textContent = `${total} fichier(s) | ${withSubject} classé(s)${analyzing > 0 ? ` | ${analyzing} en analyse` : ''}`;
        }
    }

    renderFileItemHTML(fileData) {
        const subjects = this.classifier.getAllSubjects();
        const { file, classification, selectedSubject, analyzing } = fileData;
        const fileIcon = this.classifier.getFileIcon(file.name);
        const fileSize = this.formatFileSize(file.size);

        const confidenceColor = classification.subjectConfidence >= 70 ? '#4CAF50' :
            classification.subjectConfidence >= 40 ? '#FF9800' : '#999';

        const confidenceIcon = classification.subjectConfidence >= 70 ? '✓' :
            classification.subjectConfidence >= 40 ? '~' : '?';

        return `
            <div class="file-item" data-file-id="${fileData.id}">
                <div class="file-item-header">
                    <div class="file-info">
                        <div class="file-icon" style="cursor: pointer;" title="Cliquer pour prévisualiser">${fileIcon}</div>
                        <div class="file-details">
                            <h4>${file.name}</h4>
                            <div class="file-size">${fileSize}</div>
                            ${classification.suggestedTitle !== file.name ? `
                                <div style="color: var(--primary); font-size: 0.9em; margin-top: 5px; cursor: pointer;" onclick="navigator.clipboard.writeText('${classification.suggestedTitle}'); UploadAnimations.showToast('Titre copié', 'success');" title="Cliquer pour copier">
                                    🎯 ${classification.suggestedTitle} 📋
                                </div>
                            ` : ''}
                            ${analyzing ? `
                                <div style="color: #2196F3; font-size: 0.85em; margin-top: 5px; display: flex; align-items: center; gap: 5px;">
                                    <span style="display: inline-block; animation: spin 1s linear infinite;">⌛</span>
                                    Analyse du contenu en cours...
                                </div>
                            ` : classification.analyzedContent ? `
                                <div style="color: #4CAF50; font-size: 0.85em; margin-top: 5px;">
                                    ✓ Contenu analysé
                                </div>
                            ` : ''}
                        </div>
                    </div>
                    <button class="file-remove-btn" onclick="uploadManager.removeFile(${fileData.id})">×</button>
                </div>
                
                <div class="classification-section" style="background: var(--bg-body); padding: 15px; border-radius: 10px; margin-top: 15px;">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 10px; margin-bottom: 15px;">
                        ${classification.documentType ? `
                            <div style="background: var(--card-bg); padding: 10px; border-radius: 8px; border-left: 3px solid var(--primary);">
                                <div style="font-size: 0.8em; color: #999; margin-bottom: 3px;">Type</div>
                                <div style="font-weight: 600; color: var(--text-main);">
                                    ${classification.documentTypeIcon} ${this.classifier.formatDocumentType(classification.documentType)}
                                </div>
                                <div style="font-size: 0.75em; color: ${classification.documentTypeConfidence >= 70 ? '#4CAF50' : '#FF9800'}; margin-top: 2px;">
                                    ${classification.documentTypeConfidence}%
                                </div>
                            </div>
                        ` : ''}
                        
                        ${classification.number ? `
                            <div style="background: var(--card-bg); padding: 10px; border-radius: 8px; border-left: 3px solid #2196F3;">
                                <div style="font-size: 0.8em; color: #999; margin-bottom: 3px;">Numéro</div>
                                <div style="font-weight: 600; color: var(--text-main); font-size: 1.2em;">
                                    #${classification.number}
                                </div>
                            </div>
                        ` : ''}
                        
                        ${classification.year ? `
                            <div style="background: var(--card-bg); padding: 10px; border-radius: 8px; border-left: 3px solid #FF9800;">
                                <div style="font-size: 0.8em; color: #999; margin-bottom: 3px;">Année</div>
                                <div style="font-weight: 600; color: var(--text-main);">
                                    📅 ${classification.year}
                                </div>
                            </div>
                        ` : ''}
                    </div>
                    
                    <div class="classification-label">
                        <span>Matière suggérée</span>
                        ${classification.subjectConfidence > 0 ? '<span class="ai-badge">IA</span>' : ''}
                        ${classification.analyzedContent ? '<span class="ai-badge" style="background: #2196F3;">🔍 Contenu</span>' : ''}
                    </div>
                    <div class="subject-selector">
                        <div class="searchable-select" data-file-id="${fileData.id}">
                            <input type="text" 
                                   class="subject-search-input" 
                                   placeholder="🔍 Rechercher ou sélectionner une matière..."
                                   value="${selectedSubject ? subjects.find(s => s.key === selectedSubject)?.icon + ' ' + subjects.find(s => s.key === selectedSubject)?.name : ''}"
                                   data-selected="${selectedSubject || ''}"
                                   ${analyzing ? 'disabled' : ''}
                                   autocomplete="off">
                            <div class="subject-dropdown" style="display: none;">
                                ${subjects.map(subject => `
                                    <div class="subject-option" data-value="${subject.key}">
                                        ${subject.icon} ${subject.name}
                                    </div>
                                `).join('')}
                            </div>
                        </div>
                        ${classification.subjectConfidence > 0 && classification.subject !== selectedSubject ? `
                            <button class="apply-suggestion-btn" onclick="uploadManager.applySuggestion(${fileData.id})" title="Appliquer la suggestion IA">
                                ✓ Appliquer
                            </button>
                        ` : ''}
                        ${classification.subjectConfidence > 0 ? `
                            <div class="confidence-indicator" style="color: ${confidenceColor}">
                                ${confidenceIcon} ${classification.subjectConfidence}%
                            </div>
                        ` : ''}
                    </div>
                    ${classification.matchedKeywords.length > 0 ? `
                        <div style="margin-top: 8px; font-size: 0.85em; color: #999;">
                            Mots-clés: ${classification.matchedKeywords.slice(0, 5).join(', ')}${classification.matchedKeywords.length > 5 ? '...' : ''}
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    attachSearchableSelectEvents() {
        document.querySelectorAll('.subject-search-input').forEach(input => {
            const container = input.closest('.searchable-select');
            if (!container || container.dataset.eventsAttached) return;

            container.dataset.eventsAttached = 'true';

            const dropdown = container.querySelector('.subject-dropdown');
            const fileId = parseFloat(container.dataset.fileId); // Use parseFloat as ID is Date.now() + random()

            const showDropdown = () => {
                // Fermer les autres dropdowns
                document.querySelectorAll('.subject-dropdown').forEach(d => {
                    if (d !== dropdown) d.style.display = 'none';
                });

                dropdown.style.display = 'block';
                this.filterSubjects(input, dropdown);
            };

            // Click: toggle dropdown
            input.addEventListener('click', (e) => {
                e.stopPropagation();
                showDropdown();
            });

            // Focus : afficher le dropdown
            input.addEventListener('focus', () => {
                showDropdown();
            });

            // Input : filtrer les résultats
            input.addEventListener('input', () => {
                dropdown.style.display = 'block';
                this.filterSubjects(input, dropdown);
            });

            // Keyboard navigation
            input.addEventListener('keydown', (e) => {
                if (dropdown.style.display !== 'block') {
                    showDropdown();
                }

                const options = Array.from(dropdown.querySelectorAll('.subject-option')).filter(o => o.style.display !== 'none');
                const current = dropdown.querySelector('.subject-option.highlighted');
                let index = options.indexOf(current);

                if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    if (index === -1) index = -1;
                    index = Math.min(index + 1, options.length - 1);
                    this.highlightOption(options, index);
                } else if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    index = Math.max(index - 1, 0);
                    this.highlightOption(options, index);
                } else if (e.key === 'Enter') {
                    e.preventDefault();
                    if (current) current.click();
                } else if (e.key === 'Escape') {
                    dropdown.style.display = 'none';
                    input.blur();
                }
            });

            // Click sur une option
            dropdown.querySelectorAll('.subject-option').forEach(option => {
                option.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const value = option.dataset.value;
                    const text = option.textContent.trim();
                    input.value = text;
                    input.dataset.selected = value;
                    dropdown.style.display = 'none';
                    this.updateSubject(fileId, value);
                });
            });
        });
    }

    highlightOption(options, index) {
        options.forEach((opt, i) => {
            if (i === index) {
                opt.classList.add('highlighted');
                opt.scrollIntoView({ block: 'nearest' });
            } else {
                opt.classList.remove('highlighted');
            }
        });
    }

    filterSubjects(input, dropdown) {
        const searchTerm = input.value.toLowerCase();
        const options = dropdown.querySelectorAll('.subject-option');

        options.forEach(option => {
            const text = option.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                option.style.display = 'block';
            } else {
                option.style.display = 'none';
            }
        });
    }

    applySuggestion(fileId) {
        const fileData = this.selectedFiles.find(f => f.id === fileId);
        if (fileData && fileData.classification.subject) {
            fileData.selectedSubject = fileData.classification.subject;
            this.renderFilesList();
            this.updateConfirmButton();
            UploadAnimations.showToast('Suggestion appliquée', 'success');
        }
    }

    updateSubject(fileId, subjectKey) {
        const fileData = this.selectedFiles.find(f => f.id === fileId);
        if (fileData) {
            fileData.selectedSubject = subjectKey;
            this.updateConfirmButton();
        }
    }

    removeFile(fileId) {
        this.selectedFiles = this.selectedFiles.filter(f => f.id !== fileId);
        this.renderFilesList();
        this.updateConfirmButton();
    }

    updateConfirmButton() {
        const allHaveSubject = this.selectedFiles.length > 0 &&
            this.selectedFiles.every(f => f.selectedSubject);
        document.getElementById('confirmUploadBtn').disabled = !allHaveSubject;
    }

    formatFileSize(bytes) {
        if (bytes === 0) return '0 B';
        const k = 1024;
        const sizes = ['B', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
    }

    async confirmUpload() {
        const progressDiv = document.getElementById('uploadProgress');
        const progressFill = document.getElementById('progressFill');
        const statusDiv = document.getElementById('uploadStatus');
        const confirmBtn = document.getElementById('confirmUploadBtn');

        progressDiv.style.display = 'block';
        confirmBtn.disabled = true;
        confirmBtn.textContent = 'Traitement en cours...';

        const startTime = Date.now();

        for (let i = 0; i < this.selectedFiles.length; i++) {
            const fileData = this.selectedFiles[i];
            const progress = ((i + 1) / this.selectedFiles.length) * 100;

            progressFill.style.width = progress + '%';
            statusDiv.textContent = `${i + 1}/${this.selectedFiles.length} - ${fileData.file.name}`;

            await this.processFile(fileData);
            await this.delay(300);
        }

        const duration = ((Date.now() - startTime) / 1000).toFixed(1);
        statusDiv.textContent = `✓ ${this.selectedFiles.length} document(s) classé(s) en ${duration}s`;
        statusDiv.style.color = '#4CAF50';

        await this.delay(1500);
        this.showSuccessMessage();
        this.closeModal();
    }

    async processFile(fileData) {
        const analysis = {
            fileName: fileData.file.name,
            subject: fileData.selectedSubject,
            subjectName: this.classifier.formatSubjectName(fileData.selectedSubject),
            subjectConfidence: fileData.classification.subjectConfidence,
            documentType: fileData.classification.documentType,
            documentTypeName: fileData.classification.documentType ? this.classifier.formatDocumentType(fileData.classification.documentType) : null,
            documentTypeConfidence: fileData.classification.documentTypeConfidence,
            number: fileData.classification.number,
            year: fileData.classification.year,
            suggestedTitle: fileData.classification.suggestedTitle,
            keywords: fileData.classification.matchedKeywords,
            analyzedContent: fileData.classification.analyzedContent || false,
            fileSize: fileData.file.size,
            fileType: fileData.file.type
        };

        console.log('\n=== Document analysé ===');
        console.table(analysis);
    }

    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    showSuccessMessage() {
        // Affiche un message de succès temporaire
        const message = document.createElement('div');
        message.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 20px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            z-index: 3000;
            font-weight: 600;
            animation: slideInRight 0.3s ease;
        `;
        message.innerHTML = `
            <div style="display: flex; align-items: center; gap: 10px;">
                <span style="font-size: 1.5em;">✓</span>
                <div>
                    <div style="font-size: 1.1em;">Documents ajoutés !</div>
                    <div style="font-size: 0.9em; opacity: 0.9;">${this.selectedFiles.length} fichier(s) classé(s)</div>
                </div>
            </div>
        `;

        document.body.appendChild(message);

        setTimeout(() => {
            message.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => message.remove(), 300);
        }, 3000);
    }
}

// Initialisation au chargement de la page
let uploadManager;
let advancedFeatures;
document.addEventListener('DOMContentLoaded', () => {
    uploadManager = new DocumentUploadManager();
    advancedFeatures = new AdvancedFeatures(uploadManager);
});

// Animations CSS pour les messages
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.5; }
    }
`;
document.head.appendChild(style);
