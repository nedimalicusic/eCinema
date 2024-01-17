using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class editreservation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "IsClosed",
                table: "Reservations",
                newName: "isConfirm");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "isConfirm",
                table: "Reservations",
                newName: "IsClosed");
        }
    }
}
