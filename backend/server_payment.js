const express = require("express");
const cors = require("cors");

require('dotenv').config();

const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

const app = express();
app.use(express.json());
app.use(cors());

app.post("/create-payment-intent", async (req, res) => {
  try {
    const { amount } = req.body;

    // Verificar si el monto es válido
    if (!amount || amount <= 0) {
      console.error("[ERROR] Monto inválido:", amount);
      return res.status(400).send({ error: "El monto debe ser mayor a 0" });
    }

    console.log(`[DEBUG] Monto recibido: ${amount} centavos`);

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: "mxn",
      payment_method_types: ["card"],
    });

    console.log(
      `[DEBUG] client_secret generado: ${paymentIntent.client_secret}`
    );

    res.send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.error("[ERROR]", error);
    res.status(400).send({ error: error.message });
  }
});

app.listen(3000, "0.0.0.0", () =>
  console.log("[SERVER] Backend Stripe corriendo en http://0.0.0.0:3000")
);
