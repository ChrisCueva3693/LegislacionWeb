# Stage 1: build
FROM node:18-alpine AS builder

WORKDIR /app

# Copiamos package.json y package-lock.json (o yarn.lock)
COPY package*.json ./

# Instalamos dependencias exactamente como en tu package.json
RUN npm ci

# Copiamos el resto del código y hacemos el build de producción
COPY . .
RUN npm run build

# Stage 2: servir la carpeta build
FROM node:18-alpine AS runner

WORKDIR /app

# Instala globalmente 'serve' para servir estáticos
RUN npm install -g serve

# Copiamos el build generado
COPY --from=builder /app/build ./build

# Exponemos el puerto que Railway le asigne
EXPOSE 3000

# Usamos la variable de entorno $PORT que Railway define
ENTRYPOINT ["sh", "-c", "serve -s build -l $PORT"]
