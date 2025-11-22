from pdf2image import convert_from_path
import pytesseract

def ocr_pdf(pdf_path: str) -> str:
    pages = convert_from_path(pdf_path, dpi=200)
    return "\n".join([f"--- Page {i+1} ---\n{pytesseract.image_to_string(p)}" for i, p in enumerate(pages)])