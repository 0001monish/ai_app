import faiss
import numpy as np
from sentence_transformers import SentenceTransformer
import pickle
from pathlib import Path

class VectorStore:
    def __init__(self):
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.index = None
        self.chunks = []
        self.index_path = Path("faiss.index")
        self.chunks_path = Path("chunks.pkl")

    def build(self, texts: list):
        embeddings = self.model.encode(texts)
        dim = embeddings.shape[1]
        self.index = faiss.IndexFlatL2(dim)
        self.index.add(embeddings.astype('float32'))
        self.chunks = texts
        faiss.write_index(self.index, self.index_path)
        with open(self.chunks_path, 'wb') as f:
            pickle.dump(self.chunks, f)

    def search(self, query: str, k=3):
        if not self.index:
            return []
        q_emb = self.model.encode([query])
        D, I = self.index.search(q_emb.astype('float32'), k)
        return [self.chunks[i] for i in I[0]]