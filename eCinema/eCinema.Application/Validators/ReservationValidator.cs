using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ReservationValidator : AbstractValidator<ReservationUpsertDto>
    {
        public ReservationValidator()
        {
            RuleFor(c => c.isActive).NotNull();
            RuleFor(c => c.IsClosed).NotNull();
            RuleFor(c => c.ShowSeatId).NotNull();
            RuleFor(c => c.UserId).NotNull();
        }
    }
}
