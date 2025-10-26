import os
import json
from pathlib import Path

base_path = Path(r'c:\Users\dem\Documents\test site avec tt les cours ing')
site_path = base_path / 'site-web'

# Configuration S1 et S2
semestres = {
    'S1': {
        'path': base_path / 'S1' / 'S1',
        'matieres': {
            'Anglais': ('anglais', '🇬🇧'),
            'BDD': ('bdd', '🗄️'),
            'CEF': ('cef', '🎤'),
            'Data exploration': ('data-exploration', '📊'),
            'Éthique': ('ethique', '⚖️'),
            'Gestion de l\'entreprise': ('gestion', '💼'),
            'Probabilités et simulation': ('probabilites', '🎲'),
            'Système d\'exploitation': ('systeme', '💻'),
            'Théorie des langages': ('langages', '🔤')
        }
    },
    'S2': {
        'path': base_path / 'S2' / 'S2',
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
        for item in sorted(os.listdir(folder_path)):
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
    </nav>'''

def create_page(title, icon, breadcrumb, files, subfolders, output_path, s_rel_path, semester, is_home=False):
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
            safe_name = folder.replace(' ', '-').replace('\'', '').replace('&', '').lower()
            subfolders_html += f'''
                <a href="{safe_name}.html" class="course-card-link">
                    <div class="course-card">
                        <span class="course-icon">📂</span>
                        <h2>{folder}</h2>
                    </div>
                </a>'''
        subfolders_html += '</div></div>'
    
    files_html = ''
    if files:
        files_html = '<div class="documents-section"><h2 class="section-title">📄 Fichiers</h2><div class="courses-grid">'
        for file in files:
            icon_file = get_icon(file['ext'])
            file_path = f"../{'../' * depth}{s_rel_path}/{file['name']}"
            view_btn = f'<a href="{file_path}" class="btn btn-view" target="_blank">Voir</a>' if can_preview(file['ext']) else ''
            files_html += f'''
                <div class="document-item">
                    <span class="document-name"><span class="file-icon">{icon_file}</span>{file['name']}</span>
                    <div class="document-actions">
                        {view_btn}
                        <a href="{file_path}" class="btn btn-download" download>Télécharger</a>
                    </div>
                </div>'''
        files_html += '</div></div>'
    
    scroll_btn = '''<button class="scroll-top-btn" onclick="window.scrollTo({top: 0, behavior: 'smooth'})" title="Haut de page">↑</button>'''
    
    html = f'''<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - ING1 {semester}</title>
    <link rel="stylesheet" href="{css_path}">
</head>
<body>
    <header>
        <div class="container">
            <h1>📚 ING1 - {semester}</h1>
            <p>{title}</p>
        </div>
    </header>
    {nav_bar}
    {scroll_btn}
    <main class="container">
        <div class="search-bar-container">
            <div class="search-input-wrapper">
                <input type="text" id="globalSearch" placeholder="🔍 Rechercher..." />
                <label class="search-content-label">
                    <input type="checkbox" id="searchInContent" />
                    Rechercher dans le contenu
                </label>
            </div>
            <div class="filters-wrapper">
                <select id="categoryFilter"><option value="">Toutes les matières</option></select>
                <select id="typeFilter">
                    <option value="">Tous les types</option>
                    <option value="pdf">PDF</option>
                    <option value="docx">Word</option>
                    <option value="pptx">PowerPoint</option>
                </select>
                <select id="folderFilter">
                    <option value="">Tous les dossiers</option>
                    <option value="TD">TD</option>
                    <option value="CM">CM</option>
                </select>
            </div>
        </div>
        <div id="searchResults" class="search-results-panel">
            <div id="resultsContainer"></div>
        </div>
        {'<div class="breadcrumb">' + breadcrumb_html + '</div>' if not is_home else ''}
        <div class="page-title">
            <div class="icon">{icon}</div>
            <h1>{title}</h1>
            <p>{len(files)} fichier(s) • {len(subfolders)} dossier(s)</p>
        </div>
        {subfolders_html}
        {files_html}
    </main>
    <footer>
        <div class="container">
            <p>&copy; 2024 ING1 - {semester}</p>
        </div>
    </footer>
    <script src="{js_path}"></script>
    <script src="{'../' * depth}navigation.js"></script>
</body>
</html>'''
    
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html, encoding='utf-8')

def process_semester(semester_key, config):
    s_path = config['path']
    pages_base = site_path / 'pages' / semester_key.lower()
    all_files = []
    
    for matiere_name, (folder_name, icon) in config['matieres'].items():
        matiere_path = s_path / matiere_name
        output_path = pages_base / folder_name
        
        if not matiere_path.exists():
            continue
        
        files, subfolders = scan_folder(matiere_path)
        
        for file in files:
            rel_path = (matiere_path / file['name']).relative_to(base_path)
            all_files.append({
                'name': file['name'],
                'path': f"../{str(rel_path).replace(chr(92), '/')}",
                'category': folder_name.title(),
                'type': file['ext'],
                'semester': semester_key
            })
        
        create_page(
            matiere_name, icon, [matiere_name], files, subfolders,
            output_path / 'index.html',
            f"{semester_key}/{semester_key}/{matiere_name}",
            semester_key
        )
        
        for subfolder in subfolders:
            safe_name = subfolder.replace(' ', '-').replace('\'', '').replace('&', '').lower()
            sub_path = matiere_path / subfolder
            sub_files, sub_subfolders = scan_folder(sub_path)
            
            for file in sub_files:
                rel_path = (sub_path / file['name']).relative_to(base_path)
                all_files.append({
                    'name': file['name'],
                    'path': f"../{str(rel_path).replace(chr(92), '/')}",
                    'category': folder_name.title(),
                    'folder': subfolder,
                    'type': file['ext'],
                    'semester': semester_key
                })
            
            sub_rel = sub_path.relative_to(base_path)
            create_page(
                subfolder, '📂', [matiere_name, subfolder], sub_files, sub_subfolders,
                output_path / f"{safe_name}.html",
                str(sub_rel).replace('\\', '/'),
                semester_key
            )
    
    return all_files

# Générer S1 et S2
all_files = []
for sem_key, sem_config in semestres.items():
    print(f"Generation {sem_key}...")
    all_files.extend(process_semester(sem_key, sem_config))

# Sauvegarder l'index
with open(site_path / 'files_index.json', 'w', encoding='utf-8') as f:
    json.dump(all_files, f, ensure_ascii=False, indent=2)

print(f"\nSite genere avec succes!")
print(f"- {len(all_files)} fichiers indexes")
print(f"- S1 et S2 generes")
