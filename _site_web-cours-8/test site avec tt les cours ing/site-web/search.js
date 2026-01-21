const searchInput = document.getElementById('globalSearch');
const searchResults = document.getElementById('searchResults');
const mainContent = document.getElementById('mainContent');
const typeFilter = document.getElementById('typeFilter');
const categoryFilter = document.getElementById('categoryFilter');

// Utilisation de la variable globale injectée par files.js
// Fallback array vide si le chargement échoue
const allFiles = window.allFiles || [];

function initCategoryFilter() {
    if (!categoryFilter || allFiles.length === 0) return;

    // Extraire les catégories uniques
    const categories = [...new Set(allFiles.map(f => f.category))].sort();

    // Ajouter les options
    categories.forEach(cat => {
        const option = document.createElement('option');
        option.value = cat;
        option.textContent = cat;
        categoryFilter.appendChild(option);
    });
}

const synonyms = {
    'ds': ['examen', 'partiel', 'sujet', 'eval', 'evaluation', 'controle'],
    'examen': ['ds', 'partiel', 'sujet', 'eval', 'evaluation', 'controle'],
    'correction': ['corrige', 'reponse', 'soluce', 'solution'],
    'tp': ['travaux pratique', 'lab'],
    'td': ['travaux dirig'],
    'cours': ['cm', 'magistraux'],
    'cm': ['cours', 'magistraux']
};

function normalizeText(text) {
    return text.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}

function filterFiles(query, type, category) {
    if (!query && !type && !category) return [];

    let searchTerms = [];
    if (query) {
        const normalizedQuery = normalizeText(query);
        searchTerms = [normalizedQuery];

        // Expand synonyms
        if (synonyms[normalizedQuery]) {
            searchTerms.push(...synonyms[normalizedQuery]);
        }
    }

    return allFiles.filter(file => {
        const fileName = normalizeText(file.name);

        // Check if any search term matches
        const matchName = !query || searchTerms.some(term => fileName.includes(term));
        const matchType = !type || file.type === type;
        const matchCategory = !category || (file.category && file.category === category);

        return matchName && matchType && matchCategory;
    });
}

function displayResults(results) {
    if (!searchResults) return;

    searchResults.innerHTML = '';

    if (results.length === 0) {
        searchResults.innerHTML = '<div class="no-results">Aucun résultat trouvé</div>';
        return;
    }

    // Récupération du chemin racine relatif injecté dans la page
    const rootPath = window.SITE_ROOT || '';

    results.forEach(file => {
        const resultItem = document.createElement('div');
        resultItem.classList.add('search-result-item');

        // Construction du chemin correct
        const finalPath = rootPath + file.path;

        resultItem.innerHTML = `
            <a href="${finalPath}" class="search-result-link">
                <span class="file-icon">${getIconForType(file.type)}</span>
                <div class="result-info">
                    <div class="result-name">${file.name}</div>
                    <div class="result-meta">
                        <span class="badge-type badge-${file.type}">${file.type.toUpperCase()}</span>
                        <span class="result-path">${file.semester} > ${file.category} ${file.folder ? '> ' + file.folder : ''}</span>
                    </div>
                </div>
            </a>
            <a href="${finalPath}" class="btn-download-mini" download title="Télécharger">⬇️</a>
        `;
        searchResults.appendChild(resultItem);
    });
}

function getIconForType(type) {
    const icons = {
        'pdf': '📕',
        'doc': '📘', 'docx': '📘',
        'ppt': '📙', 'pptx': '📙',
        'xls': '📗', 'xlsx': '📗',
        'zip': '📦', 'rar': '📦',
        'jpg': '🖼️', 'png': '🖼️', 'jpeg': '🖼️',
        'mp4': '🎬', 'mov': '🎬',
        'py': '🐍', 'c': '💻', 'cpp': '💻', 'java': '☕'
    };
    return icons[type] || '📄';
}

function handleSearch() {
    if (!searchInput) return;

    const query = searchInput.value.trim();
    const type = typeFilter ? typeFilter.value : '';
    const category = categoryFilter ? categoryFilter.value : '';

    // Si tout est vide, on cache les résultats et on réaffiche le contenu principal
    if (query.length === 0 && !type && !category) {
        if (searchResults) searchResults.style.display = 'none'; // Utiliser style.display pour être sûr
        if (mainContent) mainContent.style.display = 'block'; // Ou enlever une classe hidden
        return;
    }

    const results = filterFiles(query, type, category);
    displayResults(results);

    if (searchResults) searchResults.style.display = 'block';
    if (mainContent) mainContent.style.display = 'none';
}

// Init
document.addEventListener('DOMContentLoaded', () => {
    initCategoryFilter();

    if (searchInput) searchInput.addEventListener('input', handleSearch);
    if (typeFilter) typeFilter.addEventListener('change', handleSearch);
    if (categoryFilter) categoryFilter.addEventListener('change', handleSearch);
});
