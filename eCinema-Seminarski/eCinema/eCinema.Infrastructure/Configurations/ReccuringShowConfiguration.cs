using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure.Configurations
{
    public class ReccuringShowConfiguration : BaseConfiguration<ReccuringShows>
    {
        public override void Configure(EntityTypeBuilder<ReccuringShows> builder)
        {
            base.Configure(builder);


            builder.Property(e => e.StartingDate)
                     .IsRequired();

            builder.Property(e => e.EndingDate)
                 .IsRequired();

            builder.Property(e => e.ShowTime)
                 .IsRequired();

            builder.HasOne(e => e.WeekDay)
                .WithMany(e => e.ReccuringShows)
                .HasForeignKey(e => e.WeekDayId)
                .IsRequired();
        }
    }
}
