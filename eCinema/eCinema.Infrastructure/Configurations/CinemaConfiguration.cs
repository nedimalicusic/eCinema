using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class CinemaConfiguration : BaseConfiguration<Cinema>
    {
        public override void Configure(EntityTypeBuilder<Cinema> builder)
        {
            base.Configure(builder);

            builder.Property(c=>c.Name)
                .IsRequired();

            builder.Property(c=>c.Address)
                .IsRequired();

            builder.Property(c=>c.Description)
                .IsRequired();

            builder.Property(c=>c.Email)
                .IsRequired();

            builder.Property(c=>c.PhoneNumber)
                .IsRequired();

            builder.Property(c=>c.NumberOfSeats)
                .IsRequired();

            builder.HasOne(c => c.City)
                   .WithMany(c => c.Cinemas)
                   .HasForeignKey(c => c.CityId)
                   .IsRequired();
        }
    }
}
