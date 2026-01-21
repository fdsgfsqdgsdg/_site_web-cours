// Extracteur de contenu pour l'analyse des documents
class ContentExtractor {
    constructor() {
        this.maxCharsToAnalyze = 5000; // Limite pour l'analyse
    }

    // Extrait le texte d'un fichier selon son type
    async extractText(file) {
        const extension = file.name.split('.').pop().toLowerCase();
        
        try {
            if (extension === 'pdf') {
                return await this.extractFromPDF(file);
            } else if (['txt', 'md'].includes(extension)) {
                return await this.extractFromText(file);
            } else if (['doc', 'docx'].includes(extension)) {
                return await this.extractFromWord(file);
            } else if (['ppt', 'pptx'].includes(extension)) {
                return await this.extractFromPowerPoint(file);
            } else if (['py', 'java', 'js', 'c', 'cpp', 'html', 'css'].includes(extension)) {
                return await this.extractFromText(file);
            }
        } catch (error) {
            console.warn(`Impossible d'extraire le texte de ${file.name}:`, error);
        }
        
        return '';
    }

    // Extrait le texte d'un fichier texte
    async extractFromText(file) {
        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.onload = (e) => {
                const text = e.target.result.substring(0, this.maxCharsToAnalyze);
                resolve(text);
            };
            reader.onerror = () => resolve('');
            reader.readAsText(file);
        });
    }

    // Extrait le texte d'un PDF (méthode simplifiée)
    async extractFromPDF(file) {
        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.onload = async (e) => {
                try {
                    const arrayBuffer = e.target.result;
                    const uint8Array = new Uint8Array(arrayBuffer);
                    const text = this.extractTextFromPDFBuffer(uint8Array);
                    resolve(text.substring(0, this.maxCharsToAnalyze));
                } catch (error) {
                    resolve('');
                }
            };
            reader.onerror = () => resolve('');
            reader.readAsArrayBuffer(file);
        });
    }

    // Extraction basique de texte depuis un buffer PDF
    extractTextFromPDFBuffer(uint8Array) {
        let text = '';
        const decoder = new TextDecoder('utf-8', { fatal: false });
        
        // Convertit en string
        const pdfString = decoder.decode(uint8Array);
        
        // Recherche les objets texte dans le PDF (méthode simplifiée)
        const textRegex = /\(([^)]+)\)/g;
        let match;
        
        while ((match = textRegex.exec(pdfString)) !== null) {
            if (match[1]) {
                text += match[1] + ' ';
            }
        }
        
        // Recherche aussi les streams de texte
        const streamRegex = /stream\s*([\s\S]*?)\s*endstream/g;
        while ((match = streamRegex.exec(pdfString)) !== null) {
            if (match[1]) {
                const streamText = match[1].replace(/[^\x20-\x7E\u00C0-\u00FF]/g, ' ');
                text += streamText + ' ';
            }
        }
        
        return text;
    }

    // Extrait le texte d'un fichier Word (méthode simplifiée)
    async extractFromWord(file) {
        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.onload = (e) => {
                try {
                    const arrayBuffer = e.target.result;
                    const uint8Array = new Uint8Array(arrayBuffer);
                    const decoder = new TextDecoder('utf-8', { fatal: false });
                    const text = decoder.decode(uint8Array);
                    
                    // Extraction basique du texte visible
                    const cleanText = text.replace(/[^\x20-\x7E\u00C0-\u00FF]/g, ' ')
                                          .replace(/\s+/g, ' ')
                                          .substring(0, this.maxCharsToAnalyze);
                    resolve(cleanText);
                } catch (error) {
                    resolve('');
                }
            };
            reader.onerror = () => resolve('');
            reader.readAsArrayBuffer(file);
        });
    }

    // Extrait le texte d'un PowerPoint (méthode simplifiée)
    async extractFromPowerPoint(file) {
        return await this.extractFromWord(file); // Même méthode pour simplifier
    }
}

// Export
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ContentExtractor;
}
