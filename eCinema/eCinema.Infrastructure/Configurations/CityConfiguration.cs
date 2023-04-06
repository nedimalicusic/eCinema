using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class CityConfiguration : BaseConfiguration<City>
    {
        public override void Configure(EntityTypeBuilder<City> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Name)
                   .IsRequired();

            builder.Property(e => e.ZipCode)
                   .IsRequired();

            builder.Property(e => e.IsActive)
                   .IsRequired();

            builder.HasOne(e => e.Country)
                   .WithMany(e => e.Cities)
                   .HasForeignKey(e => e.CountryId)
                   .IsRequired();

        }
    }
}
