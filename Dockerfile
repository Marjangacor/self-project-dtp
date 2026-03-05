# STAGE 1: Build (Menggunakan image lengkap)
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# STAGE 2: Production (Image hasil akhir yang sangat kecil)
FROM node:18-alpine
WORKDIR /app
# Hanya ambil file yang diperlukan dari stage builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/src ./src
RUN npm install --production

# Menghapus cache untuk optimasi tambahan
RUN rm -rf /root/.npm

EXPOSE 3000
CMD ["node", "src/index.js"]
