import os
import json
from pathlib import Path
from urllib.parse import quote
import re
import zipfile

# Utilisation de chemins relatifs au script
base_path = Path(__file__).parent.parent # Chemin vers le dossier racine (contenant tous_les_cours)
site_path = Path(__file__).parent # On génère le site dans le dossier du script (site-web)

# Configuration S1 et S2
semestres = {
    'S1': {
        'path': base_path / 'tous_les_cours' / 'S1' / 'S1',
        'matieres': {
            'Anglais': ('anglais', '🇬🇧'),
            'BDD': ('bdd', '🗄️'),
            'CEF': ('cef', '🎤'),
            'Data exploration': ('data-exploration', '📊'),
            'Éthique': ('ethique', '⚖️'),
            'Gestion de l\'entreprise': ('gestion', '💼'),
            'Histoire et design': ('histoire-et-design', '📜'),
            'Probabilités et simulation': ('probabilites', '🎲'),
            'Système d\'exploitation': ('systeme', '💻'),
            'Théorie des langages': ('langages', '🔤'),
            'Introduction Python': ('python', '🐍')
        }
    },
    'S2': {
        'path': base_path / 'tous_les_cours' / 'S2' / 'S2',
        'matieres': {
            'ADO - Architecture des ordinateurs': ('ado', '🖥️'),
            'Algo avancé': ('algo', '🧮'),
            'Créativité & Innovation': ('creativite', '💡'),
            'DevWeb': ('devweb', '🌐'),
            'English': ('english', '🇬🇧'),
            'Éthique': ('ethique', '⚖️'),
            'Gestion de l\'entreprise': ('gestion', '💼'),
            'Interaction & coopération': ('interaction', '🤝'),
            'Java': ('java', '☕'),
            'Optimisation linéaire': ('optimisation', '📈')
        }
    }
}

# Configuration du dossier partagé
shared_path = base_path / 'tous_les_cours' / 'Travail ING 1 partagé 1er semestre'
shared_mapping = {
    'Anglais': ['Anglais'],
    'CEF': ['Communication et expression'],
    'Histoire et design': ['Histoire et design'],
    'Éthique': ['Éthique et sciences'],
    'BDD': ['CM/Bases de données', 'TD/Bases de données'], # Mapping multiple
    'Data exploration': ['TD/Data exploration'],
    'Gestion de l\'entreprise': ['TD/Gestion de entreprise'],
    'Probabilités et simulation': ['TD/Probabilité et simulation'],
    'Système d\'exploitation': ['TD/Systèmes exploitation'],
    'Théorie des langages': ['TD/Théorie des langages'],
    'Introduction Python': ['TD/Python']
}

def get_icon(ext):
    icons = {
        'pdf': '📄', 'docx': '📝', 'doc': '📝', 'pptx': '📊', 'ppt': '📊',
        'txt': '📃', 'sql': '🗃️', 'jpg': '🖼️', 'jpeg': '🖼️', 'png': '🖼️',
        'heic': '🖼️', 'mp4': '🎥', 'ts': '🎥', 'pages': '📝', 'bash': '⚙️',
        'R': '📊', 'csv': '📊', 'loo': '📐', 'lo1': '📐', 'mwb': '🗄️',
        'jff': '📐', 'py': '🐍', 'java': '☕', 'c': '📝', 'cpp': '📝', 'h': '📝',
        'html': '🌐', 'css': '🎨', 'js': '📜', 'json': '📋', 'xml': '📋'
    }
    return icons.get(ext, '📎')

def can_preview(ext):
    return ext in ['pdf', 'txt', 'jpg', 'jpeg', 'png', 'mp4', 'html']

def scan_folder(folder_path):
    files, subfolders = [], []
    try:
        # Tri insensible à la casse pour un ordre plus naturel
        for item in sorted(os.listdir(folder_path), key=str.lower):
            item_path = folder_path / item
            if item_path.is_file():
                ext = item.split('.')[-1].lower() if '.' in item else ''
                files.append({'name': item, 'ext': ext})
            elif item_path.is_dir() and not item.startswith('.'):
                subfolders.append(item)
    except:
        pass
    return files, subfolders

def create_nav_bar(current_semester, home_path='index.html'):
    s1_path = home_path if current_semester == 'S1' else home_path.replace('index.html', '../index.html') if 'index.html' in home_path else home_path
    s2_path = home_path.replace('index.html', 's2.html') if current_semester == 'S1' else home_path if current_semester == 'S2' else home_path
    
    return f'''<nav class="semester-nav">
        <div class="nav-left">
            <button class="nav-action-btn" onclick="window.history.back()" title="Page précédente">← Retour</button>
            <button class="nav-action-btn" onclick="window.history.forward()" title="Page suivante">Suivant →</button>
        </div>
        <div class="nav-center">
            <a href="{s1_path}" class="nav-link home" title="Accueil S1">🏠 Accueil</a>
            <a href="{s1_path}" class="nav-link {'active' if current_semester == 'S1' else ''}">📚 S1</a>
            <a href="{s2_path}" class="nav-link {'active' if current_semester == 'S2' else ''}">📚 S2</a>
        </div>
        <div class="nav-right">
            <button class="nav-action-btn zoom-btn" id="zoomOut" title="Dézoomer">A-</button>
            <button class="nav-action-btn zoom-btn" id="zoomReset" title="Réinitialiser">100%</button>
            <button class="nav-action-btn zoom-btn" id="zoomIn" title="Zoomer">A+</button>
        </div>
    </nav>'''

def detect_file_category(filename):
    name = filename.lower()
    if any(k in name for k in ['corr', 'correction', 'reponse', 'soluce', 'ds', 'examen', 'partiel', 'eval', 'rattrapage', 'sujet', 'annale']): return '🎓 Examens, DS & Corrections', 2
    if any(k in name for k in ['tp', 'travaux pratique', 'lab', 't.p']): return '🛠️ Travaux Pratiques (TP)', 3
    if any(k in name for k in ['td', 'travaux dirig', 'exercices', 't.d']): return '📝 Travaux Dirigés (TD)', 2
    if any(k in name for k in ['cm', 'cours', 'chapitre', 'lecture', 'slide', 'diapo', 'present', 'introduction']): return '📚 Cours Magistraux', 1
    if any(k in name for k in ['projet', 'project', 'devoir', 'homework', 'dm', 'rendu', 'task', 'challenge', 'defi']): return '🚀 Projets & Devoirs', 5
    if any(k in name for k in ['methode', 'guide', 'how', 'cv', 'lettre', 'mail', 'exemple', 'template', 'consigne']): return '📘 Méthodologie & Guides', 6
    if any(k in name for k in ['fiche', 'resume', 'summary', 'memo', 'synthese', 'recap']): return '📑 Fiches & Résumés', 7

    # Tri par extension pour les divers
    ext = filename.split('.')[-1].lower() if '.' in filename else ''
    if ext in ['r', 'py', 'js', 'html', 'css', 'java', 'c', 'cpp', 'h', 'sql', 'bash', 'sh']: return '💻 Scripts & Code', 50
    if ext in ['xls', 'xlsx', 'csv', 'ods']: return '📊 Données & Tableaux', 53
    if ext in ['ppt', 'pptx', 'key']: return '📢 Présentations', 54
    if ext in ['zip', 'rar', '7z', 'tar', 'gz']: return '📦 Archives', 55
    if ext in ['jpg', 'jpeg', 'png', 'gif', 'svg', 'heic']: return '🖼️ Images', 56
    
    
    return '📂 Documents Divers', 99

def extract_year(filename):
    # Match 20XX-20XX or 20XX-XX or 20XX
    match = re.search(r'(20\d{2})[-_]?((?:20)?\d{2})', filename) 
    if match:
        start = match.group(1)
        end_part = match.group(2)
        if len(end_part) == 2:
            end = "20" + end_part
        else:
            end = end_part
        return f"{start}-{end}"
    
    # Simple Year fallback
    match_simple = re.search(r'(20\d{2})', filename)
    if match_simple:
        return match_simple.group(1)
        
    return ""


def sanitize_name_dir(name):
    return name.replace(' ', '-').replace("'", "").replace('&', '').lower()

def sanitize_name_zip(name):
    # Logic to match create_page zip naming
    safe_name = name.replace(' ', '_').replace("'", "").lower()
    if safe_name == 'racine': safe_name = 'cours_s1' # Default fallback, handled differently in call sites usually
    return f"{safe_name}_complet.zip"

def create_page(title, icon, breadcrumb, files, subfolders, output_path, s_rel_path, semester, is_home=False, zip_path=None):
    try:
        rel_to_pages = output_path.relative_to(site_path / 'pages')
        depth = len(rel_to_pages.parts)
    except:
        depth = 0 if is_home else 1
    
    css_path = '../' * depth + 'style.css' if depth > 0 else 'style.css'
    js_path = '../' * depth + 'search.js' if depth > 0 else 'search.js'
    home_path = '../' * depth + ('index.html' if semester == 'S1' else 's2.html')
    
    nav_bar = create_nav_bar(semester, home_path)
    
    breadcrumb_html = f'<a href="{home_path}">🏠 {semester}</a>'
    if not is_home:
        for i, crumb in enumerate(breadcrumb[:-1]):
            link = '../' * (len(breadcrumb) - i - 1) + 'index.html'
            breadcrumb_html += f'<span>›</span><a href="{link}">{crumb}</a>'
        breadcrumb_html += f'<span>›</span><strong>{breadcrumb[-1]}</strong>'
    
    subfolders_html = ''
    if subfolders:
        subfolders_html = '<div class="folders-section"><h2 class="section-title">📁 Dossiers</h2><div class="courses-grid">'
        for folder in subfolders:
            safe_name = sanitize_name_dir(folder)
            
            # Check for zip existence
            zip_name = sanitize_name_zip(folder)
            zip_path_server = output_path.parent / safe_name / zip_name
            
            download_btn = ''
            if zip_path_server.exists():
                download_link = f"{safe_name}/{zip_name}"
                download_btn = f'''
                    <a href="{download_link}" class="btn-card-download" title="Télécharger le dossier {folder}" download>
                        ⬇️
                    </a>'''
            
            subfolders_html += f'''
                <div class="course-card-wrapper" style="position:relative;">
                    <a href="{safe_name}/index.html" class="course-card-link">
                        <div class="course-card">
                            <span class="course-icon">📂</span>
                            <h2>{folder}</h2>
                        </div>
                    </a>
                    {download_btn}
                </div>'''
        subfolders_html += '</div></div>'
    
    # Groupement des fichiers
    grouped_files = {}
    for file in files:
        cat_name, priority = detect_file_category(file['name'])
        if cat_name not in grouped_files: grouped_files[cat_name] = {'priority': priority, 'files': []}
        grouped_files[cat_name]['files'].append(file)
    
    sorted_categories = sorted(grouped_files.items(), key=lambda x: x[1]['priority'])
    
    # Collect Years
    years_set = set()
    for cat_name, data in grouped_files.items():
        for f in data['files']:
            y = extract_year(f['name'])
            f['year'] = y
            if y: years_set.add(y)
            
    sorted_years = sorted(list(years_set), reverse=True)
    year_options = ""
    for y in sorted_years:
        year_options += f'<option value="{y}">{y}</option>'

    # Génération du Sommaire (TOC)
    toc_html = ''
    if sorted_categories:
        for cat_name, data in sorted_categories:
            safe_cat_id = cat_name.replace(' ', '-').replace('&', '').replace('\'', '').lower()
            count = len(data['files'])
            toc_html += f'''
            <a href="#section-{safe_cat_id}" class="toc-item">
                <span class="toc-name">{cat_name}</span>
                <span class="toc-count">{count}</span>
            </a>'''

    # Génération des Boutons de Filtre
    filter_buttons_html = ''
    if sorted_categories:
        for cat_name, data in sorted_categories:
            safe_cat_id = cat_name.replace(' ', '-').replace('&', '').replace('\'', '').lower()
            filter_buttons_html += f'<button class="filter-btn" data-category="{safe_cat_id}" onclick="filterCategory(\'{safe_cat_id}\')">{cat_name}</button>'
    
    files_html = ''
    if files:
        files_html = '<div class="documents-section">'
        for cat_name, data in sorted_categories:
            safe_cat_id = cat_name.replace(' ', '-').replace('&', '').replace('\'', '').lower()
            files_html += f'<h2 id="section-{safe_cat_id}" class="section-title">{cat_name}</h2><div class="courses-grid">'
            for file in data['files']:
                icon_file = get_icon(file['ext'])
                if 'rel_link' in file:
                    file_path = file['rel_link']
                else:
                    file_path = f"../{'../' * depth}{s_rel_path}/{file['name']}"
                
                view_btn = f'<a href="{file_path}" class="btn btn-view" target="_blank">Voir</a>' if can_preview(file['ext']) else ''
                
                # Add data-year attribute
                year_attr = f'data-year="{file.get("year", "")}"'
                
                files_html += f'''
                    <div class="document-item" {year_attr}>
                        <span class="document-name">
                            <span class="file-icon">{icon_file}</span>
                            <span class="badge-type badge-{file['ext']}">{file['ext'].upper()}</span>
                            {file['name']}
                        </span>
                        <div class="document-actions">
                            {view_btn}
                            <a href="{file_path}" class="btn btn-download" download>Télécharger</a>
                        </div>
                    </div>'''
            files_html += '</div>'
        files_html += '</div>'
    
    scroll_btn = '''<button class="scroll-top-btn" onclick="window.scrollTo({top: 0, behavior: 'smooth'})" title="Haut de page">↑</button>'''
    
    theme_script = '''
    <script>
        function toggleTheme() {
            const html = document.documentElement;
            const current = html.getAttribute('data-theme');
            const next = current === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            document.cookie = "theme=" + next + "; path=/; max-age=31536000"; // 1 year persistence
            updateIcon(next);
        }
        function updateIcon(theme) {
            const btn = document.getElementById('themeToggle');
            if(btn) btn.innerHTML = theme === 'dark' ? '☀️' : '🌙';
        }
        
        // Immediate application to prevent flash
        let saved = localStorage.getItem('theme');
        if (!saved) {
            const match = document.cookie.match(new RegExp('(^| )theme=([^;]+)'));
            if (match) saved = match[2];
        }
        if (!saved) saved = 'light';
        
        document.documentElement.setAttribute('data-theme', saved);
        document.addEventListener('DOMContentLoaded', () => { updateIcon(saved); });

        function applyFilters() {
            // Get States
            const activeCategoryBtn = document.querySelector('.filter-btn.active-filter');
            const categoryId = activeCategoryBtn ? activeCategoryBtn.dataset.category : '';
            
            const yearSelect = document.getElementById('yearFilter');
            const yearVal = yearSelect ? yearSelect.value : '';
            
            // Apply to all items
            const sections = document.querySelectorAll('.documents-section .section-title');
            
            sections.forEach(section => {
                const grid = section.nextElementSibling;
                const sectionId = section.id.replace('section-', '');
                
                // 1. Check Category Visibility
                const isCatMatch = !categoryId || sectionId === categoryId;
                
                // 2. Check Items inside this Category
                let visibleCount = 0;
                if (grid) {
                    const items = grid.querySelectorAll('.document-item');
                    items.forEach(item => {
                        const itemYear = item.dataset.year || '';
                        const isYearMatch = !yearVal || itemYear === yearVal;
                        
                        if (isYearMatch && isCatMatch) {
                            item.style.display = '';
                            visibleCount++;
                        } else {
                            item.style.display = 'none';
                        }
                    });
                }
                
                // 3. Toggle Section Visibility based on children
                // Note: The original logic hid sections based on Category.
                // Now we hide sections if Category doesn't match OR if no children are visible (due to Year)
                
                if (isCatMatch && visibleCount > 0) {
                     section.style.display = '';
                     if(grid) grid.style.display = '';
                } else {
                     section.style.display = 'none';
                     if(grid) grid.style.display = 'none';
                }
            });
        }

        function filterCategory(categoryId) {
            const buttons = document.querySelectorAll('.filter-btn');
            const activeClass = 'active-filter';

            // Reset buttons
            buttons.forEach(btn => {
                if (btn.dataset.category === categoryId) {
                    btn.classList.add(activeClass);
                } else {
                    btn.classList.remove(activeClass);
                }
            });
            
            applyFilters();
        }
        
        function filterYear() {
            applyFilters();
        }
    </script>'''
    
    html = f'''<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - ING1 {semester}</title>
    <link rel="stylesheet" href="{css_path}">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    {theme_script}
    <script>window.SITE_ROOT = "{'../' * depth}";</script>
    <script src="{'../' * depth}files.js"></script>
    <script src="{js_path}" defer></script>
</head>
<body>
    <header>
        <div class="header-top-row">
            <button id="themeToggle" class="theme-toggle" onclick="toggleTheme()" title="Changer de thème">🌙</button>
        </div>
        <div class="container">
            <a href="{home_path}" style="text-decoration: none; color: inherit; display: block;">
                <h1>📚 ING1 - {semester}</h1>
                <p>{title}</p>
            </a>
        </div>
    </header>
    {nav_bar}
    {scroll_btn}
    <main class="container">
        <div class="search-bar-container">
            <div class="search-input-wrapper"><input type="text" id="globalSearch" placeholder="🔍 Rechercher..." /></div>
            <div class="filters-wrapper">
                <select id="categoryFilter" style="display:none"><option value="">Toutes les matières</option></select>
                <select id="yearFilter" onchange="filterYear()"><option value="">Toutes les années</option>{year_options}</select>
                <select id="typeFilter"><option value="">Tous les types</option><option value="pdf">PDF</option><option value="docx">Word</option></select>
            </div>
        </div>
        
        <!-- Filter Chips -->
        <div class="filter-chips-container">
            <div class="filter-label">Filtrer par catégorie :</div>
            <div class="filter-chips">
                <button class="filter-btn active-filter" onclick="filterCategory('')">Tout afficher</button>
                {filter_buttons_html}
            </div>
        </div>

        <!-- Table of Contents / Sommaire -->
        <div class="toc-container">
            <h3>📑 Sommaire</h3>
            <div class="toc-grid">
                {toc_html}
            </div>
        </div>

        <div id="searchResults" class="search-results-panel"><div id="resultsContainer"></div></div>
        {'<div class="breadcrumb">' + breadcrumb_html + '</div>' if not is_home else ''}
        <div class="page-title">
            <div class="icon">{icon}</div>
            <h1>{title}</h1>
            <p>{len(files)} fichier(s) • {len(subfolders)} dossier(s)</p>
            {f'<a href="{zip_path}" class="btn btn-download-all" download>📦 Tout télécharger (.zip)</a>' if zip_path else ''}
        </div>
        {files_html}
        {subfolders_html}
    </main>
    <footer><div class="container"><p>&copy; 2024 ING1 - {semester} • Design Premium</p></div></footer>
    <script src="{'../' * depth}navigation.js"></script>
</body>
</html>'''
    
    # Remplacement du placeholder toc_html
    # Note: On a mis {toc_html} dans la f-string HTML plus haut, donc c'est déjà bon si toc_html est défini AVANT.
    # Ah, attention, j'ai défini 'html' avec une f-string qui utilise 'toc_html'.
    # Il faut s'assurer que 'toc_html' est défini avant 'html = f...'.
    # C'est le cas dans mon code ajouté plus haut.
    
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html, encoding='utf-8')

def process_semester(semester_key, config):
    s_path = config['path']
    pages_base = site_path / 'pages' / semester_key.lower()
    all_files = []
    
    for matiere_name, (folder_name, icon) in config['matieres'].items():
        # Chemins sources potentiels : Principal + Partagé
        source_paths = []
        
        # 1. Chemin principal S1/S1/...
        main_path = s_path / matiere_name
        if main_path.exists():
            source_paths.append(main_path)
            
        # 2. Chemins partagés (Seulement pour S1)
        if semester_key == 'S1' and matiere_name in shared_mapping:
            for sub_path in shared_mapping[matiere_name]:
                full_shared = shared_path / sub_path
                if full_shared.exists():
                    source_paths.append(full_shared)
        
        if not source_paths:
            continue
            
        print(f"Traîtement de {matiere_name} avec sources : {[str(p) for p in source_paths]}")
        
        # Création de la page racine de la matière
        # On va scanner TOUS les chemins sources et tout fusionner dans le dossier de sortie
        output_dir = pages_base / folder_name
        
        # Pour faire propre, on va appeler process_recursive_wrapper pour chaque source,
        # MAIS en pointant vers le MEME output_dir.
        # Attention : si on a des fichiers de même nom, ils s'écraseront ou s'ajouteront.
        # Notre logique create_page écrase index.html à chaque fois.
        # Il faut donc :
        # 1. Scanner TOUS les fichiers de TOUTES les sources d'abord.
        # 2. Construire une structure unifiée en mémoire ?
        # OU BIEN : on modifie process_recursive pour accepter une LISTE de folder_paths.
        
        # Simplification : On traite chaque source. 
        # Si on appelle process_recursive_wrapper 2 fois sur le même output_dir, 
        # la 2ème fois va réécrire le index.html avec SEULEMENT les fichiers de la 2ème source.
        # C'est un problème. create_page n'est pas "additif".
        
        # Solution : On collecte TOUS les fichiers et sous-dossiers de TOUTES les sources au niveau racine.
        combined_files = []
        combined_subfolders = [] # Liste de noms
        
        # On doit aussi gérer la récursion. C'est complexe si les structures de sous-dossiers divergent.
        # Approche pragmatique : Le dossier partagé est "à plat" ou presque (CM/TD).
        # On va considérer que le dossier partagé est une source de fichiers à ajouter à la racine de la matière,
        # OU BIEN on respecte ses sous-dossiers.
        
        # On va modifier process_recursive_wrapper pour prendre une LISTE de chemins racines.
        all_files.extend(process_merged_sources(
            source_paths,
            output_dir,
            [matiere_name],
            semester_key,
            folder_name.title(),
            icon_root=icon
        ))

    return all_files

def scan_multiple_folders(folder_paths):
    all_files = []
    all_subfolders = set() # Set pour éviter doublons de noms
    
    for path in folder_paths:
        f, s = scan_folder(path)
        all_files.extend(f) # On garde tout, même si doublon de nom (peu probable ou pas grave)
        all_subfolders.update(s)
        
    return all_files, sorted(list(all_subfolders))

# Nouvelle fonction récursive supportant le merge
def process_merged_sources(folder_paths, output_dir, breadcrumb, semester, category_name, icon_root=None):
    # Scan combiné
    files, subfolders = scan_multiple_folders(folder_paths)
    all_files_found = []
    
    curr_icon = icon_root if icon_root else '📂'
    
    # 1. Indexation
    for path in folder_paths:
        # On doit savoir de quel path vient quel fichier pour le lien relatif correct
        # On re-scan localement pour associer le path
        # C'est un peu inefficace mais sûr.
        local_files, _ = scan_folder(path)
        for file in local_files:
            # Note: files contient l'union de tout, on itère ici juste pour retrouver le path parent
            file_rel_path = path / file['name']
            
            try:
                rel_path_str = str(file_rel_path.relative_to(base_path)).replace('\\', '/')
            except:
                continue
            
            json_path = f"../{rel_path_str}"
            
            all_files_found.append({
                'name': file['name'],
                'path': json_path,
                'category': category_name,
                'folder': breadcrumb[-1] if len(breadcrumb) > 1 else 'Racine',
                'type': file['ext'],
                'semester': semester
            })

    # 2. Génération Page (Unique pour cet output_dir)
    # Problème : pour les boutons "Voir/Télécharger", on a besoin du chemin relatif correct pour chaque fichier.
    # create_page reçoit une liste de dict simple {'name': ..}. Il lui manque le 'origin_path'.
    # On doit enrichir la structure 'files' passée à create_page.
    
    rich_files = []
    for path in folder_paths:
        local_files, _ = scan_folder(path)
        for file in local_files:
            file_rel_path = path / file['name']
            # Calcul du chemin relatif depuis l'output_dir HTML vers le fichier source
            # output_dir est ex: site-web/pages/s1/matiere
            # file est ex: tous_les_cours/Shared/Matiere/file.pdf
            # On veut aller de output_dir à file.
            
            try:
                # On utilise os.path.relpath car pathlib relative_to exige une hiérarchie stricte
                rel_link = os.path.relpath(file_rel_path, output_dir)
                rel_link = rel_link.replace('\\', '/')
                # Encodage URL pour gérer les espaces et caractères spéciaux
                rel_link = quote(rel_link)
            except:
                rel_link = '#'
                
            rich_files.append({
                'name': file['name'],
                'ext': file['ext'],
                'rel_link': rel_link,  # Nouveau champ pour create_page
                'full_path': file_rel_path # Stockage du chemin complet pour le zip
            })

    # 2.5 Génération du ZIP (avec les rich_files qui ont les paths corrects)
    # On veut créer un zip contenant les fichiers de CE dossier.
    zip_rel_link = None
    if rich_files:
        try:
            # Nom du zip : nom du dossier courant
            safe_folder_name = breadcrumb[-1].replace(' ', '_').replace("'", "").lower()
            if safe_folder_name == 'racine': safe_folder_name = f'cours_{semester.lower()}'
            
            zip_name = f"{safe_folder_name}_complet.zip"
            zip_output_path = output_dir / zip_name
            
            # Création du zip
            with zipfile.ZipFile(zip_output_path, 'w', zipfile.ZIP_DEFLATED) as zf:
                for rf in rich_files:
                    # On ajoute le fichier à la racine du zip
                    zf.write(rf['full_path'], arcname=rf['name'])
            
            # Calcul du lien relatif vers le zip pour le bouton
            zip_rel_link = zip_name # Comme c'est dans le même dossier
            
        except Exception as e:
            print(f"Erreur ZIP pour {output_dir}: {e}")

    # create_page doit être adaptée pour utiliser rel_link si présent, sinon fallback
    # On passera rel_path_for_links='.' et on se fiera à rel_link dans files
    

    # 3. Récursion (MOVED UP)
    for sub in subfolders:
        safe_name = sanitize_name_dir(sub)
        
        # On cherche ce sous-dossier dans TOUS les parents qui l'ont
        next_paths = []
        for p in folder_paths:
            candidate = p / sub
            if candidate.is_dir():
                next_paths.append(candidate)
        
        if next_paths:
            sub_files_found = process_merged_sources(
                next_paths,
                output_dir / safe_name,
                breadcrumb + [sub],
                semester,
                category_name,
                icon_root=None 
            )
            all_files_found.extend(sub_files_found)
            
    # 4. Generate Page (MOVED DOWN - After Recursion so we know about child zips)
    create_page(
        breadcrumb[-1],
        curr_icon,
        breadcrumb,
        rich_files, # Liste enrichie
        subfolders,
        output_dir / 'index.html',
        None, # s_rel_path ignore car rel_link pré-calculé
        semester,
        zip_path=zip_rel_link
    )
        
    return all_files_found

# Générer S1 et S2
all_files = []
for sem_key, sem_config in semestres.items():
    print(f"Generation {sem_key}...")
    all_files.extend(process_semester(sem_key, sem_config))

# Sauvegarder l'index
# Sauvegarder l'index en JSON et JS
with open(site_path / 'files_index.json', 'w', encoding='utf-8') as f:
    json.dump(all_files, f, ensure_ascii=False, indent=2)

# Générer files.js
js_content = f"window.allFiles = {json.dumps(all_files, ensure_ascii=False, indent=2)};"
(site_path / 'files.js').write_text(js_content, encoding='utf-8')

print(f"\nSite genere avec succes!")
print(f"- {len(all_files)} fichiers indexes")
print(f"- S1 et S2 generes")
