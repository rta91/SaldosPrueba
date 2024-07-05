using System.Data;
using System.Data.SqlClient;

namespace SaldosPrueba
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //Cadena de conexión de prueba utilizando Integrated Security
            string connectionString = "Data Source=.;Initial Catalog=PruebaRaul;Integrated Security=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Ejecutar procedimiento almacenado sp_AsignarSaldosAGestores
                    using (SqlCommand command = new SqlCommand("sp_AsignarSaldosAGestores", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Leer los resultados del procedimiento almacenado
                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            DataTable table = new DataTable();
                            adapter.Fill(table);

                            // Imprimir los resultados en la consola
                            Console.WriteLine("Resultados de procedimiento de asignación de saldos");
                            Console.WriteLine("---------------------------------------------------");

                            // Encabezados
                            Console.WriteLine("{0,-20} {1,-20}", "Nombre Gestor", "Saldo Asignado");
                            Console.WriteLine("---------------------------------------------------");

                            // Iterar y Formatear la salida
                            foreach (DataRow row in table.Rows)
                            {
                                Console.WriteLine("{0,-20} {1,-20}",
                                    row["Nombre"],
                                    row["Saldo"]);
                            }

                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error al ejecutar el procedimiento almacenado: " + ex.Message);
                }
            }

            Console.WriteLine("Presiona cualquier tecla para salir...");
            Console.ReadKey();
        }
    
}
    }

