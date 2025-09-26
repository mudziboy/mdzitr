const axios = require('axios');
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./sellvpn.db');

// ✅ CREATE VMESS
async function createvmess(username, exp, quota, limitip, serverId) {
  console.log(`⚙️ Creating VMESS for ${username} | Exp: ${exp} | Quota: ${quota} GB | IP Limit: ${limitip}`);

  if (/\s/.test(username) || /[^a-zA-Z0-9]/.test(username)) {
    return '❌ Username tidak valid. Gunakan hanya huruf dan angka tanpa spasi.';
  }

  return new Promise((resolve) => {
    db.get('SELECT * FROM Server WHERE id = ?', [serverId], async (err, server) => {
      if (err || !server) {
        console.error('❌ DB Error:', err?.message || 'Server tidak ditemukan');
        return resolve('❌ Server tidak ditemukan.');
      }

      const url = `http://${server.domain}:5888/createvmess?user=${username}&exp=${exp}&quota=${quota}&iplimit=${limitip}&auth=${server.auth}`;

      try {
        const { data } = await axios.get(url);

        if (data.status !== 'success') {
          console.error('❌ Gagal dari API:', data.message);
          return resolve(`❌ Gagal membuat akun: ${data.message}`);
        }

        const d = data.data;

        // Pesan teks
const messageText = `
🌟 *SAGI MARKET VMESS* 🌟

┌───☠️───────────────☠️───┐
│ *Username*   : \`${vmessData.username}\`
│ *Domain*     : \`${vmessData.domain}\`
│ *Port TLS*   : \`443\`
│ *Port HTTP*  : \`80\`
│ *Alter ID*   : \`0\`
│ *Security*   : \`Auto\`
│ *Network*    : \`Websocket (WS)\`
│ *Path*       : \`/vmess\`
│ *Path GRPC*  : \`vmess-grpc\`
└─────💀─────☠️────💀────┘

⚙️ *Petunjuk Singkat*
• Salin \`vmess\` credential di atas.
• Gunakan path \`/vmess\` untuk koneksi WebSocket.
• Untuk bantuan, klik tombol di bawah ini.
`;

// Inline button
const replyMarkup = {
  inline_keyboard: [
    [
      { text: "Hubungi Admin", url: "https://t.me/rahmarie" }
    ]
  ]
};

// Contoh pengiriman pakai node-telegram-bot-api
bot.sendMessage(chatId, messageText, {
  parse_mode: "Markdown",
  reply_markup: replyMarkup
});

🔗 *VMESS TLS:*
\`\`\`
${d.vmess_tls_link}
\`\`\`
🔗 *VMESS NON-TLS:*
\`\`\`
${d.vmess_nontls_link}
\`\`\`
🔗 *VMESS GRPC:*
\`\`\`
${d.vmess_grpc_link}
\`\`\`

🧾 *UUID:* \`${d.uuid}\`
🔏 *PUBKEY:* \`${d.pubkey}\`
┌─────────────────────
│🕒 *Expired:* \`${d.expired}\`
│
│📥 [Save Account](https://${d.domain}:81/vmess-${d.username}.txt)
└─────────────────────
✨ By : *SAGI MARKET VVIP*! ✨
`.trim();

        console.log('✅ VMESS created for', username);
        resolve(msg);

      } catch (e) {
        console.error('❌ Error saat request ke API:', e.message);
        resolve('❌ Tidak bisa menghubungi server. Coba lagi nanti.');
      }
    });
  });
}

module.exports = { createvmess };