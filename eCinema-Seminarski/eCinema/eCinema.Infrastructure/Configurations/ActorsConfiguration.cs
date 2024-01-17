using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class ActorsConfiguration : BaseConfiguration<Actors>
    {
        public override void Configure(EntityTypeBuilder<Actors> builder)
        {
            base.Configure(builder);

            builder.Property(a => a.FirstName)
                .IsRequired();

            builder.Property(a => a.LastName)
                .IsRequired();

            builder.Property(a => a.Email)
                .IsRequired();

            builder.Property(a => a.BirthDate)
               .IsRequired();

            builder.Property(a => a.Gender)
                .IsRequired();
        }
    }
}
