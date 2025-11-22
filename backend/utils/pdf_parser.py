import fitz

def extract_text_with_pages(pdf_path: str):
    doc = fitz.open(pdf_path)
    return [(i + 1, doc.load_page(i).get_text()) for i in range(len(doc))]