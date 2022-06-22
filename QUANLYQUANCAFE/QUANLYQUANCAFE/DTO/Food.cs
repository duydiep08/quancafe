using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QUANLYQUANCAFE.DTO
{
    public class Food
    {
        public Food(int id, string name, int categoryID, float price)
        {
            this.ID = id;
            this.Name = name;
            this.CategoryID = categoryID;
            this.Price = price;
        }

        public Food(DataRow row)
        {
            this.ID = (int)row["id"];
            this.Name = row["name"].ToString();
            this.CategoryID = (int)row["idcategory"];
            this.Price = (float)Convert.ToDouble(row["price"].ToString());
        }

        private int iD;
        private int categoryID;
        private string name;
        private float price;
        public int ID { get => iD; set => iD = value; }
        public int CategoryID { get => categoryID; set => categoryID = value; }
        public string Name { get => name; set => name = value; }
        public float Price { get => price; set => price = value; }
    }
}
