const express = require("express");
const app = express();
const mongoose = require("mongoose");
const Product = require("./product");
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const productData = [];

async function connectToMongoDB() {
    try {
        await mongoose.connect("mongodb+srv://jyoti:NAME@NAME.hnq6sdb.mongodb.net/ExpiryShield")

        app.post("/api/add_product", async (req, res) => {
            console.log("Result ", req.body);
            let data = Product(req.body);
            try {
                const dataToStore = await data.save();
                res.status(200).json(dataToStore);
            } catch (error) {
                res.status(400).json({
                    "status": error.message
                })
                console.log(error)
            }
        });

        app.get("/api/get_product", async (req, res) => {
            try {
                let data = await Product.find();
                res.status(200).json(data);
            } catch (error) {
                res.status(500).json(error.message);
            }
        });

        app.get("/api/get_product/:id", async (req, res) => {
            try {
                let data = await Product.findById(req.params.id);
                res.status(200).json(data);
            } catch (error) {
                res.status(500).json(error.message);
            }
        });

        app.patch("/api/update/:id", async (req, res) => {
            let id = req.params.id;
            let updateData = req.body;
            let options = { new: true };
            try {
                const data = await Product.findByIdAndUpdate(id, updateData, options);
                res.send(data);
            } catch (error) {
                res.send(error.message);
            }
        });

        app.delete("/api/delete/:id", async (req, res) => {
            const id = req.params.id;
            try {
                const data = await Product.findByIdAndDelete(id);
                if (!data) {
                    return res.status(404).send({
                        'status': "error",
                        'message': "Product not found"
                    });
                }
                res.json({
                    'status': "success",
                    'message': `Deleted the product ${data.pname} from the database`
                });
            } catch (error) {
                console.log("Error deleting product:", error.message);
                res.status(500).json({
                    'status': "error",
                    'message': "An error occurred while deleting the product"
                });
            }
        });
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('Error connecting to MongoDB:', error.message);
    }
}
connectToMongoDB()
    .then(() => {
        app.listen(2000, () => {
            console.log("Connected to server at 2000");
        });
    })
    .catch((error) => {
        console.error('Error starting server:', error.message);
    });