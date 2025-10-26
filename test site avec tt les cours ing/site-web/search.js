let allFiles = [];
let filesLoaded = false;

fetch('../../files_index.json')
    .then(response => response.json())
    .then(data => {
        allFiles = data;
        filesLoaded = true;
    })
    .catch(() => {
        fetch('../files_index.json')
            .then(response => response.json())
            .then(data => {
                allFiles = data;
                filesLoaded = true;
            })
            .catch(() => {
                fetch('files_index.json')
                    .then(response => response.json())
                    .then(data => {
                        allFiles = data;
                        filesLoaded = true;
                    });
            });
    });

const fallbackFiles = [
    {name: "Company organisation & structure.pdf", path: "../S1/S1/Anglais/Company organisation & structure.pdf", category: "Anglais", type: "pdf"},
    {name: "Correction eval anglais.docx", path: "../S1/S1/Anglais/Correction eval anglais.docx", category: "Anglais", type: "docx"},
    {name: "Homework - 24_11_2023.pages", path: "../S1/S1/Anglais/Homework - 24_11_2023.pages", category: "Anglais", type: "pages"},
    {name: "Management.docx", path: "../S1/S1/Anglais/Management.docx", category: "Anglais", type: "docx"},
    {name: "Présentation1.ppt ING1 school year curriculum.ppt", path: "../S1/S1/Anglais/Présentation1.ppt ING1 school year curriculum.ppt", category: "Anglais", type: "ppt"},
    {name: "toeic.txt", path: "../S1/S1/Anglais/toeic.txt", category: "Anglais", type: "txt"},
    {name: "Cours 1 - Entité Association MCD.pdf", path: "../S1/S1/BDD/Cours 1 - Entité Association MCD.pdf", category: "BDD", folder: "Cours", type: "pdf"},
    {name: "Examen-BDD-2022-23-Rattrapage.pdf", path: "../S1/S1/BDD/Examen-BDD-2022-23-Rattrapage.pdf", category: "BDD", folder: "Examens", type: "pdf"},
    {name: "Examen-BDD-2022-23.pdf", path: "../S1/S1/BDD/Examen-BDD-2022-23.pdf", category: "BDD", folder: "Examens", type: "pdf"},
    {name: "Exercice MCD Golf Club.pdf", path: "../S1/S1/BDD/Exercice MCD Golf Club.pdf", category: "BDD", folder: "Exercices", type: "pdf"},
    {name: "MLD.jpg", path: "../S1/S1/BDD/MLD.jpg", category: "BDD", type: "jpg"},
    {name: "pokemon_tables.sql", path: "../S1/S1/BDD/pokemon_tables.sql", category: "BDD", folder: "TD", type: "sql"},
    {name: "pokemon_tables_ex2.sql", path: "../S1/S1/BDD/pokemon_tables_ex2.sql", category: "BDD", folder: "TD", type: "sql"},
    {name: "Pokemons.png", path: "../S1/S1/BDD/Pokemons.png", category: "BDD", type: "png"},
    {name: "Pokemons2.png", path: "../S1/S1/BDD/Pokemons2.png", category: "BDD", type: "png"},
    {name: "Pokemons3.png", path: "../S1/S1/BDD/Pokemons3.png", category: "BDD", type: "png"},
    {name: "A voix haute.ts", path: "../S1/S1/CEF/A voix haute.ts", category: "CEF", type: "ts"},
    {name: "dossier L'art de parler.pdf", path: "../S1/S1/CEF/dossier L'art de parler.pdf", category: "CEF", type: "pdf"},
    {name: "FICHEPARTIESDUDISCOURS.pdf", path: "../S1/S1/CEF/FICHEPARTIESDUDISCOURS.pdf", category: "CEF", type: "pdf"},
    {name: "Les parties du discours .pdf", path: "../S1/S1/CEF/Les parties du discours .pdf", category: "CEF", type: "pdf"},
    {name: "MAH00109.MP4", path: "../S1/S1/CEF/MAH00109.MP4", category: "CEF", type: "mp4"},
    {name: "Séance 1 CEF 3 apprentis copy.pptx", path: "../S1/S1/CEF/Séance 1 CEF 3 apprentis copy.pptx", category: "CEF", type: "pptx"},
    {name: "Séance 1 CEF 3 apprentis.pptx", path: "../S1/S1/CEF/Séance 1 CEF 3 apprentis.pptx", category: "CEF", type: "pptx"},
    {name: "cours.docx", path: "../S1/S1/Data exploration/cours.docx", category: "Data Exploration", type: "docx"},
    {name: "EST - CM1 - Introduction à l'éthique des sciences et des techniques.pdf", path: "../S1/S1/Éthique/EST - CM1 - Introduction à l'éthique des sciences et des techniques.pdf", category: "Éthique", folder: "CM", type: "pdf"},
    {name: "EST - CM2 - L'idée de progrès.pdf", path: "../S1/S1/Éthique/EST - CM2 - L'idée de progrès.pdf", category: "Éthique", folder: "CM", type: "pdf"},
    {name: "EST - CM3 - L'éthique environnementale - 10-10-2023.pptx", path: "../S1/S1/Éthique/EST - CM3 - L'éthique environnementale - 10-10-2023.pptx", category: "Éthique", folder: "CM", type: "pptx"},
    {name: "EST - CM4 - Enjeux éthico-politiques du numérique - 03-11-2023.pptx", path: "../S1/S1/Éthique/EST - CM4 - Enjeux éthico-politiques du numérique - 03-11-2023.pptx", category: "Éthique", folder: "CM", type: "pptx"},
    {name: "EST - CM4-5 - Enjeux éthico-politiques du numérique - 10-11-2023.pptx", path: "../S1/S1/Éthique/EST - CM4-5 - Enjeux éthico-politiques du numérique - 10-11-2023.pptx", category: "Éthique", folder: "CM", type: "pptx"},
    {name: "EST - S4 - Introduction à la bioéthique - 01-12-2023.pptx", path: "../S1/S1/Éthique/EST - S4 - Introduction à la bioéthique - 01-12-2023.pptx", category: "Éthique", folder: "CM", type: "pptx"},
    {name: "Plan du module Ethiques, sciences et techniques (EST) - 06-09-23.pdf", path: "../S1/S1/Éthique/Plan du module Ethiques, sciences et techniques (EST) - 06-09-23.pdf", category: "Éthique", type: "pdf"},
    {name: "Examen-Comptabilité-Générale-ING1-2021-2022.pdf", path: "../S1/S1/Gestion de l'entreprise/Examen-Comptabilité-Générale-ING1-2021-2022.pdf", category: "Gestion", folder: "Examens", type: "pdf"},
    {name: "fiche.pdf", path: "../S1/S1/Gestion de l'entreprise/fiche.pdf", category: "Gestion", type: "pdf"},
    {name: "Le compte de résultat.pdf", path: "../S1/S1/Gestion de l'entreprise/Le compte de résultat.pdf", category: "Gestion", type: "pdf"},
    {name: "TD1.pdf", path: "../S1/S1/Gestion de l'entreprise/TD1.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "TD2.pdf", path: "../S1/S1/Gestion de l'entreprise/TD2.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "TD3.pdf", path: "../S1/S1/Gestion de l'entreprise/TD3.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "TD4-Cas-ALPHA.pdf", path: "../S1/S1/Gestion de l'entreprise/TD4-Cas-ALPHA.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "TD5- Journal-Leron-Philppot.pdf", path: "../S1/S1/Gestion de l'entreprise/TD5- Journal-Leron-Philppot.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "TD6 Réductions commerciales RRR ET Réductions financières.pdf", path: "../S1/S1/Gestion de l'entreprise/TD6 Réductions commerciales RRR ET Réductions financières.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "TD7-La facturation ALPHA.pdf", path: "../S1/S1/Gestion de l'entreprise/TD7-La facturation ALPHA.pdf", category: "Gestion", folder: "TD", type: "pdf"},
    {name: "Ch1.pdf", path: "../S1/S1/Probabilités et simulation/Ch1.pdf", category: "Probabilités", folder: "Cours", type: "pdf"},
    {name: "Ch2 - Suite de variables aléatoires réelles convergentes .pdf", path: "../S1/S1/Probabilités et simulation/Ch2 - Suite de variables aléatoires réelles convergentes .pdf", category: "Probabilités", folder: "Cours", type: "pdf"},
    {name: "Examen_ProbabilitesEtSimulation_Ing1-GIA_2022-01-xx.pdf", path: "../S1/S1/Probabilités et simulation/Examen_ProbabilitesEtSimulation_Ing1-GIA_2022-01-xx.pdf", category: "Probabilités", folder: "Examens", type: "pdf"},
    {name: "Examen_ProbabilitesEtSimulation_Ing1-GMA_2023-01-xx.pdf", path: "../S1/S1/Probabilités et simulation/Examen_ProbabilitesEtSimulation_Ing1-GMA_2023-01-xx.pdf", category: "Probabilités", folder: "Examens", type: "pdf"},
    {name: "Standard_Normale_Distribution_Table.pdf", path: "../S1/S1/Probabilités et simulation/Standard_Normale_Distribution_Table.pdf", category: "Probabilités", type: "pdf"},
    {name: "TD1.pdf", path: "../S1/S1/Probabilités et simulation/TD1.pdf", category: "Probabilités", folder: "TD", type: "pdf"},
    {name: "Cours.docx", path: "../S1/S1/Système d'exploitation/Cours.docx", category: "Système", type: "docx"},
    {name: "Schéma.docx", path: "../S1/S1/Théorie des langages/Schéma.docx", category: "Langages", type: "docx"}
];

if (!filesLoaded) {
    allFiles = fallbackFiles;
}

function getFileIcon(type) {
    const icons = {
        'pdf': '📄', 'docx': '📝', 'doc': '📝', 'pptx': '📊', 'ppt': '📊',
        'txt': '📃', 'sql': '🗃️', 'jpg': '🖼️', 'jpeg': '🖼️', 'png': '🖼️',
        'heic': '🖼️', 'mp4': '🎥', 'ts': '🎥', 'pages': '📝'
    };
    return icons[type] || '📎';
}

function canPreview(type) {
    return ['pdf', 'txt', 'jpg', 'jpeg', 'png', 'mp4'].includes(type);
}

function performSearch() {
    const query = document.getElementById('globalSearch').value.toLowerCase();
    const categoryFilter = document.getElementById('categoryFilter').value;
    const typeFilter = document.getElementById('typeFilter').value;
    const folderFilter = document.getElementById('folderFilter').value;
    const searchInContent = document.getElementById('searchInContent')?.checked || false;
    
    if (!query && !categoryFilter && !typeFilter && !folderFilter) {
        document.getElementById('searchResults').style.display = 'none';
        return;
    }
    
    let results = allFiles.filter(file => {
        let matchQuery = !query;
        
        if (query) {
            matchQuery = file.name.toLowerCase().includes(query) || 
                        file.category.toLowerCase().includes(query) ||
                        (file.folder && file.folder.toLowerCase().includes(query));
            
            if (!matchQuery && searchInContent && file.content) {
                matchQuery = file.content.includes(query);
            }
        }
        
        const matchCategory = !categoryFilter || file.category === categoryFilter;
        const matchType = !typeFilter || file.type === typeFilter;
        const matchFolder = !folderFilter || file.folder === folderFilter;
        
        return matchQuery && matchCategory && matchType && matchFolder;
    });
    
    displayResults(results);
}

function displayResults(results) {
    const container = document.getElementById('searchResults');
    const resultsDiv = document.getElementById('resultsContainer');
    
    if (results.length === 0) {
        resultsDiv.innerHTML = '<div class="no-results">Aucun résultat trouvé</div>';
        container.style.display = 'block';
        return;
    }
    
    resultsDiv.innerHTML = `
        <div class="results-header">
            <h3>${results.length} résultat${results.length > 1 ? 's' : ''} trouvé${results.length > 1 ? 's' : ''}</h3>
            <button onclick="closeSearch()" class="close-btn">✕</button>
        </div>
        ${results.map(file => `
            <div class="search-result-item">
                <div class="result-info">
                    <span class="file-icon">${getFileIcon(file.type)}</span>
                    <div class="result-details">
                        <div class="result-name">${file.name}</div>
                        <div class="result-meta">
                            <span class="badge">${file.category}</span>
                            ${file.folder ? `<span class="badge-folder">${file.folder}</span>` : ''}
                        </div>
                    </div>
                </div>
                <div class="result-actions">
                    ${canPreview(file.type) ? `<a href="${file.path}" class="btn btn-view" target="_blank">Voir</a>` : ''}
                    <a href="${file.path}" class="btn btn-download" download>Télécharger</a>
                </div>
            </div>
        `).join('')}
    `;
    
    container.style.display = 'block';
}

function closeSearch() {
    document.getElementById('searchResults').style.display = 'none';
    document.getElementById('globalSearch').value = '';
    document.getElementById('categoryFilter').value = '';
    document.getElementById('typeFilter').value = '';
    document.getElementById('folderFilter').value = '';
}

document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('globalSearch');
    if (searchInput) {
        searchInput.addEventListener('input', performSearch);
    }
    
    const searchInContent = document.getElementById('searchInContent');
    if (searchInContent) {
        searchInContent.addEventListener('change', performSearch);
    }
    
    ['categoryFilter', 'typeFilter', 'folderFilter'].forEach(id => {
        const filter = document.getElementById(id);
        if (filter) {
            filter.addEventListener('change', performSearch);
        }
    });
});
