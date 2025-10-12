import React from "react";

/**
 * Componente para mostrar videos de YouTube con estilo navegador.
 * Acepta un `videoId` o una URL completa de YouTube.
 */
export default function BrowserVideo({ url, videoId }) {
  const extractVideoId = (youtubeUrl) => {
    if (!youtubeUrl) return null;
    try {
      const urlObj = new URL(youtubeUrl);
      return urlObj.searchParams.get("v");
    } catch {
      return null;
    }
  };

  const id = videoId || extractVideoId(url);
  if (!id) return <p style={{ color: "red" }}>⚠️ URL o ID de vídeo no válido</p>;

  return (
    <div className="my-8 w-[90%] max-w-3xl mx-auto shadow-xl rounded-xl overflow-hidden border border-gray-300 dark:border-gray-700">
      {/* Barra superior tipo navegador */}
      <div className="bg-gray-100 dark:bg-gray-800 flex items-center gap-2 px-4 py-2 border-b border-gray-300 dark:border-gray-700">
        <div className="h-3 w-3 bg-red-500 rounded-full"></div>
        <div className="h-3 w-3 bg-yellow-400 rounded-full"></div>
        <div className="h-3 w-3 bg-green-500 rounded-full"></div>
      </div>

      {/* Marco del vídeo */}
      <div className="relative w-full" style={{ paddingBottom: "52%" }}>
        <iframe
          className="absolute top-0 left-0 w-full h-full rounded-b-xl"
          src={`https://www.youtube.com/embed/${id}`}
          title="YouTube video player"
          frameBorder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowFullScreen
        ></iframe>
      </div>
    </div>
  );
}
